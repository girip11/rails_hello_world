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
