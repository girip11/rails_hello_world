# Rails Tutorial notes

```bash
rails generate controller StaticPages home help

# undo/delete the files generated using the above command
rails destroy controller StaticPages home help

# Generate model files and delete generated files
rails generate model User name:string email:string

rails destroy model User
```

* Controller name passed to `rails generate controller` can be in **PascalCase** as well as in **snake_case**

```bash
# Both of these commands generate a controller
# class called StaticPagesController with the file named as
# static_pages_controller.rb inside app/controllers
rails generate controller StaticPages home help

rails generate controller static_pages home help
```

Controller generation automatically updates the **config/routes.rb**

* Migrate and undo migration

```bash
rails db:migrate

# migrates to the input version number
rails db:migrate VERSION=<version>

rails db:rollback
```

* Test driven development - Red, Green and Refactoe

* The distinction between the two types of embedded Ruby is that <% ... %> executes the code inside, while <%= ... %> executes it and inserts the result into the template.

* Setting up guard to run tests automatically.

```bash
bundle exec guard init

# guard console
# Press enter to run all the tests
bundle exec guard
```

## Assets pipeline

> The asset pipeline combines all the application stylesheets into one CSS file (application.css), combines all the application JavaScript into one JavaScript file (application.js), and then minifies them to remove the unnecessary spacing and indentation that bloats file size

### Asset Directories

* app/assets: Assets specific to the present application
* lib/assets: In case of creating a ruby library(gem), assets go in to this folder
* vendor/assets: assets from third-party vendors

### Manifest files

* Manifest files used by Rails bundling resources(applies to CSS and Javascript) in to single files via the Sprockets gem.

```CSS
/*
 *= require_tree .
 *= require_self
*/
```

* `*= require_tree .` All CSS files under `app/assets/stylesheets` (including subdirectories) will be included in to **application.css** and finally includes **application.css** itself, so that the css rules defined in that file are given higher priority.

### Preprocessor engines

3 preprocessor engines commonly used

* **.scss** - SASS preprocessor
* **.coffee** - Coffee script (Converts to javascript)
* **.erb** - Embedded ruby

* `foobar.js.erb.coffee` - Gets run through both CoffeeScript first and then ERb, with the code running from right to left

## Links in rails

* **Hardcoding links is not** the rails way.

* For instance, `<a href="/static_pages/about">About</a>` snippet can be written in ruby as `<%= link_to "About", about_path %>`. Advantage of using helpers like **about_path** is change in the url is automatically reflected.

## Named routes

* Since **_path** contains the relative url, we prefer using this form compared to the **_url** form since refering using absolute urls would cause additional DNS lookup.

* Only when doing redirects we prefer **_url** form.

```ruby
# root_path contains the relative url
root_path: '/'

# root_url contains the absolute url
root_url: 'http://www.example.com'
```

* Defining shorter routes

```ruby
# verbose route
get 'static_pages/help'

# Short route
# Below route creates two paths help_path and help_route
# help_path -> '/help'
# help_url  -> 'http://www.example.com/help'
get  '/help', to: 'static_pages#help'
```

* To get all the routes in the application use the below snippet

```ruby
# https://stackoverflow.com/questions/341143/can-rails-routing-helpers-i-e-mymodel-pathmodel-be-used-in-models

route_module = Rails.application.routes.url_helpers

puts route_module.class.name # its a module

# this will list all the route helpers for a rails application
route_module.public_methods(false).sort

route_module.public_methods(false).select do |method|
  method.to_s.include?("_path") ||
  method.to_s.include?("_url")
end

puts route_module.about_path
puts route_module.about_url(host: "example.com") # prints http://example.com/about
```

---

## Rails Models

* The default Rails solution to the problem of persistence is to use a database for long-term data storage, and the default library for interacting with the database is called Active Record

* In contrast to the plural convention for controller names, model names are singular: a Users controller, but a User model.

* The table name is plural (users) even though the model name is singular (User), which reflects a linguistic convention followed by Rails: a model represents a single user, whereas a database table consists of many users

* [Rails migration documentation]([guides.rubyonrails.org/migrations.html](https://edgeguides.rubyonrails.org/active_record_migrations.html))

* `rails console --sandbox` - In rails sandbox environment, any modifications you make will be rolled back on exit.

```ruby
john = User.new(name: "John", email: "john@example.com")

if john.valid? && john.save
  puts "User saved successfully to DB"
end

# To create a user object and save it to
# database in one step use the `create` method
# `create` method returns the user object
jane = User.new(name: "Jane", email: "jane@example.com")

# deletes the user from db
jane.destroy

# get all users
User.all.to_a.each {|user| puts user.name}

# to see where the methods like name and email come from
jane.method(:name).owner

# to list all the methods on the User attributes
jane.method(:name).owner.instance_methods(false)

# To find a user by id
# A nonexistent Active Record id causes `find` to raise an
# ActiveRecord::RecordNotFound exception
usr = User.find(3)

# Find user by attributes
usr = User.find_by(email:"jane@example.com")

# new syntax
usr = User.find_by_email("jane@example.com")
```

## Updating user objects

* Using `save` method

```ruby
user = User.find_by_email("jane@example.com")
puts user.email
user.email = "jane_doe@example.com"
user.save

puts user.created_at
puts user.updated_at

# `reload` fetches the database information and reloads the object
user.email = "jane@example.org"

# if the object is reloaded before save, the changes will be lost
puts user.reload.email # prints jane_doe@example.com
```

* Using `update_attributes` method

```ruby
user = User.find_by_email("john@example.com")

# this method accepts a hash of attributes
# object is updated only after the validation.
user.update_attributes(name: "John Doe", email: "john_doe@example.com")

# To update single attribute
# this method bypasses the model validation
user.update_attribute(:name, "John_Doe")
```

## Model validations

* `validates` - method for validating model fields

```ruby
# validates :name, presence: true
usr = User.new(email: "jacob@example.com")
usr.valid?

# to get the error messages
puts usr.errors.full_messages

errors_hash = usr.errors.messages

puts errors_hash[:name]
```

* Format validation

```ruby
validates :email, format: {with: /regex/}
```

| Regex                                | Meaning                                           |
| ------------------------------------ | ------------------------------------------------- |
| /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i | full regex                                        |
| /                                    | start of regex                                    |
| \A                                   | match start of a string                           |
| [\w+\-.]+                            | at least one word character, plus, hyphen, or dot |
| @                                    | literal “at sign”                                 |
| [a-z\d\-.]+                          | at least one letter, digit, hyphen, or dot        |
| \.                                   | literal dot                                       |
| [a-z]+                               | at least one letter                               |
| \z                                   | match end of a string                             |
| /                                    | end of regex                                      |
| i                                    | case-insensitive                                  |

## Uniqueness

`validates` method accepts the following options for ensuring uniqueness of a field

* `uniqueness: true` - case sensitive uniqueness
* `uniqueness: { case_sensitive: false }` - case insensitive uniqueness.

**The Active Record uniqueness validation does not guarantee uniqueness at the database level**. Here’s a scenario that explains why:

* Alice signs up for the sample app, with address alice@wonderland.com.
* Alice accidentally clicks on “Submit” twice, sending two requests in quick succession.
* The following sequence occurs: request 1 creates a user in memory that passes validation, request 2 does the same, request 1’s user gets saved, request 2’s user gets saved.
* Result: two user records with the exact same email address, despite the uniqueness validation

In such cases, it is always better to enforce uniqueness at the database level.

## Database indices

Adding a database index avoids a full table scan and increases the look up efficiency.

> To understand a database index, it’s helpful to consider the analogy of a book index. In a book, to find all the occurrences of a given string, say “foobar”, you would have to scan each page for “foobar”—the paper version of a full-table scan. With a book index, on the other hand, you can just look up “foobar” in the index to see all the pages containing “foobar”. A database index works essentially the same way.

**NOTE**: If rails database migration fails or gets stuck, try exiting any running sandbox console sessions, which can lock the database and prevent migrations.

## Fixtures

* Fixtures contains sample data for the test database.
* Fixture data doesn’t get run through the validations.
* Fixtures support embedded Ruby

* Active record life cycle is associated with callbacks
  * `before_save`
  * `after_save` etc

```ruby
class User < ApplicationRecord
  before_save { self.email = email.downcase }
end
```

## User authentication

> The method for authenticating users will be to take a submitted password, hash it, and compare the result to the hashed value stored in the database. If the two match, then the submitted password is correct and the user is authenticated. By comparing hashed values instead of raw passwords, we will be able to authenticate users without storing the passwords themselves. This means that, even if our database is compromised, our users’ passwords will still be secure.

`has_secure_password` uses a hash function called **bcrypt**. When `has_secure_password` is included in a model, it adds the following functionality:

* The ability to save a securely hashed **password_digest** attribute to the database
* A pair of virtual attributes (password and password_confirmation), including presence validations upon object creation and a validation requiring that they match
* An `authenticate` method that returns the user when the password is correct (and false otherwise)

The only requirement for `has_secure_password` to work its magic is for the corresponding model to have an attribute called **password_digest**.

```ruby
rails generate migration add_password_digest_to_users password_digest:string
```

## Rails environment

* Rails supports the following environments by default
  * development
  * test
  * production

```ruby
# To print the current environment name
puts Rails.env

# Checking the current rails environment
Rails.env.development?

# Launching rails console in an environment
bundle exec rails console # default env is development
bundle exec rails console test

# Launching rails server
bundle exec rails server -e development
bundle exec rails server -e test
bundle exec rails server --environment production

# Running database migration
bundle exec rails db:migrate RAILS_ENV=production
```

## `debug` method in rails views

* Adding `debug(params)` to rails views renders the following HTML

```HTML
<pre class="debug_dump">
---
!ruby/object: ActionController::Parameters
parameters: !ruby/hash:ActiveSupport::HashWithIndifferentAccess
  controller: static_pages
  action: home
permitted: false
</pre>
```

* This is a YAML representation of `params`

```ruby
user = User.find(1)
user_yaml = user.attributes.to_yaml

# To get the YAML representation of a ruby model object
puts user_yaml

# shorthand for `puts user.attributes.to_yaml` is using the method `y`
y user.attributes
```

## Rails REST Architecture

> REST architecture favored in Rails applications - representing data as resources that can be created, shown, updated, or destroyed—four actions corresponding to the four fundamental operations POST, GET, PATCH, and DELETE defined by the HTTP standard.

* Routes based on REST in rails for a User resource

| HTTP request | URL           | Action  | Named route          | Purpose                          |
| ------------ | ------------- | ------- | -------------------- | -------------------------------- |
| GET          | /users        | index   | users_path           | page to list all users           |
| GET          | /users/1      | show    | user_path(user)      | page to show user                |
| GET          | /users/new    | new     | new_user_path        | page to make a new user (signup) |
| POST         | /users        | create  | users_path           | create a new user                |
| GET          | /users/1/edit | edit    | edit_user_path(user) | page to edit user with id 1      |
| PATCH        | /users/1      | update  | user_path(user)      | update user                      |
| DELETE       | /users/1      | destroy | user_path(user)      | delete user                      |

## Debugger

* Uses **byebug** gem. Just need to add a line consisting of `debugger` to required controller action.

```ruby
class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    debugger
  end

end
```

* The **Rails server** shows a byebug prompt. We can treat this like **rails console**.

* To release the prompt and continue execution of the application, press **Ctrl-D**, then remove the debugger line from the show action.

> Whenever you’re confused about something in a Rails application, it’s a good practice to put debugger close to the code you think might be causing the trouble. Inspecting the state of the system using byebug is a powerful method for tracking down application errors and interactively debugging your application.

**NOTE**: By default, **methods defined in any helper file are automatically available in any view**

## Strong parameters

> Passing in a raw params hash will cause an error to be raised, so that Rails applications are now immune to mass assignment vulnerabilities by default.

```ruby
params.require(:user).permit(:name, :email, :password, :password_confirmation)
```

## Shared Partials

> This reflects the common Rails convention of using a dedicated **shared/** directory for partials expected to be used in views across multiple controllers.

## `render` and `redirect_to`

* `render` - renders a template
* `redirect_to` - redirects to a url which may render a view template

## Flash message

* `flash` - hash like method. Used to display flash messages on the website.

* Inside the controller the below code sets the flash.

```ruby
flash[:success] = "Sign up successful!"
```

* To use the `flash` inside the views

```ruby
<% flash.each do |message_type, message| %>
  <%= "<div class=\"alert alert-#{message_type}\">#{message}</div>"  %>
<% end %>
```

## Testing in rails

* [Testing rails application](https://guides.rubyonrails.org/testing.html)

## Sessions and Temporary cookies

* Most common implementation of session in rails uses cookies.
* `session` - Rails method to create temporary sessions. Sessions expire on browser close.

* In rails, a session is persisted in cookies. A session is treated like a RESTful resource.

* `session[:user_id] = user.id` creates a temporary cookie. These cookies are automatically encrypted.

## Flash message and `render`

* Re-rendering a template with `render` doesn’t count as a request. Flash message will be displayed in more page.

* Replace `flash` with the special variant `flash.now`, which is specifically designed for displaying flash messages on rendered pages.

## Persistent sessions

* Rails provides `cookies` - for persisting sessions. Vulnerable to session hijacking.

* Information stored using `session` - secure

* A cookie consists of two pieces of information, a value and an optional expires date

```ruby
cookies[:remember_token] = { value:   remember_token,
                             expires: 20.years.from_now.utc }

```

* This pattern of setting a cookie that expires 20 years in the future is so common that Rails has a special `permanent` method to implement it, so that we can simply write

```ruby
cookies.permanent[:remember_token] = remember_token
```

* Signed cookie - encrypts the cookie before placing in the browser.

```ruby
# setting the cookie securely
cookies.permanent.signed[:user_id] = user.id

# retrieving data from the cookie after automatic decrypting
puts cookies.signed[:user_id]
```

## Rails `POST` for create and `PATCH` for update

When constructing a form using `form_for(@user)`, Rails uses `POST` if `@user.new_record?` is `true` and `PATCH` if it is `false`

## Rails partials

* [Utilizing View partials](http://tutorials.jumpstartlab.com/topics/better_views/view_partials.html)

* `render` by default, looks for the partial in the same directory as the current view template.

```erb
<!-- This renders the partial _comments.html.erb -->
<%= render partial: "comments" %>

<!-- If the partial is relocated to folder like shared -->
<%= render partial: "shared/comments" %>
```

* Variables can be passed to the partials using `locals` options which takes a `Hash`.

```erb
 <!--render partial option is clubbed with locals option for passing data  -->
<!-- Within the comments partial variable `article` can be used -->
 <%= render partial: "shared/comments", locals: {article: @article} %>

<!-- above syntax can be shortened as -->
 <%= render "shared/comments", article: @article %>
```

* Whenever we have an iteration loop in a view template, it is a candidate for extraction to a collection partial

* In case of rendering collections, each item by default is stored in the variable having same name as the partials file name.

```erb
<ul id='articles'><%= render partial: 'article', collection: @articles %></ul>

<!-- above syntax can be shortened as -->
<ul id='articles'><%= render @articles %></ul>
```

## Rails redirect

* Redirects don’t happen until an explicit `return` or **the end of the method**, so any code appearing after the redirect is still executed.

## ActiveRecord callbacks

* A `before_save` callback is automatically called before the object is saved, which includes both object **creation and updation**.

* `before_create` - called only before the rails model gets created.

## Rails named route and query parameters

* When using named routes to define query parameters, Rails automatically escapes out any special characters.

```ruby
# http://www.example.com/account_activations/q5lt38hQDc_959PVoo6b7A/edit?email=foo%40example.com
edit_account_activation_url(@user.activation_token, email: @user.email)

# Print the below statement in the rails console
puts Rails.application.routes.url_helpers.edit_account_activation_url(user.activation_token, email: user.email, host: "www.example.com")
```

---

## References

* [Rails 5 tutorial](https://www.learnenough.com/ruby-on-rails-4th-edition-tutorial/modeling_users)
