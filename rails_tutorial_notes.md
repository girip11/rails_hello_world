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
