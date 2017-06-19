== README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


Please feel free to use a different markup language if you do not plan to run
<tt>rake doc:app</tt>.

rails new geoworkflow -T
rails g scaffold user username:string auth_token:string role:string
rails g scaffold process_type user:references name:references hashtag:string description:text
rails g scaffold my_process process_type:references user:references address:string latitude:float longitude:float starts_at:datetime
rails g scaffold task my_process:references user:references address:string latitude:float longitude:float starts_at:datetime ends_at:datetime responsible_user:references
