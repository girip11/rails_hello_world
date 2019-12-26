# Notes

* The argument of the scaffold command is the singular version of the resource name.

* Configure the **config/database.yml** to connect to the postgresql database. After changes in database.yml the rails server should be restarted.

```YAML
development:
  <<: *default
  database: toy_app_development
  username: postgres
  password: postgres
  host: localhost
  port: 5432
  schema_search_path: public
test:
  <<: *default
  database: toy_app_test
  username: postgres
  password: postgres
  host: localhost
  port: 5432
  schema_search_path: public
```

* Run the scaffolding command

```bash
bundle exec rails g scaffold User name:string email:string

bundle exec rails  db:migrate
# or
# Rake is **R**uby M**ake**
bundle exec rake db:migrate
```

* User routes and actions

| URL           | Action | Purpose                     |
| ------------- | ------ | --------------------------- |
| users         | index  | page to list all users      |
| /users/1      | show   | page to show user with id 1 |
| /users/new    | new    | page to make a new user     |
| /users/1/edit | edit   | page to edit user with id 1 |

* `bundle exec rake routes` displays all the routes

* Instance variables of a controller are automatically available to the views.

* Rails association between models help access associated micropost instances from user and viceversa

* Launch rails console using the command `bundle exec rails console`

* It is by inheriting from ActiveRecord::Base that our model objects gain the ability to communicate with the database, treat the database columns as Ruby attributes, and so on.

* controllers gain a large amount of functionality by inheriting from a base class (in this case, ActionController::Base), including the ability to manipulate model objects, filter inbound HTTP requests, and render views as HTML
