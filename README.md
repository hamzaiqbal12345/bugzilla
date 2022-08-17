## Bugzilla - bug tracking application
This project is basically the implementation of a bug tracking system. There are three user roles[Manager, Developer, Quality assurance].

Manager can create new/edit projects.

Manager can assign/unassign developers/qas to the project.

Developers can view the projects they are enrolled to.

Developers can view the bugs, and can assign themselves the bug.

Quality assurance can see all projects

Quality assurance can add bugs to the project.

Authenticated manager can create the project

Unauthenticated manager cannot create the project
##### 1. Check out the repository
```bash
git clone https://github.com/hamzaiqbal12345/bugzilla.git
```
##### 2. Create database.yml file
Copy the sample database.yml file and edit the database configuration as required.
```bash
cp config/database.yml.sample config/database.yml
```
##### 3. Create and setup the database
Run the following commands to create and setup the database.
```ruby
rails db:create
rails db:setup
```
##### 3. Install gems using bundler
```ruby
Run bundle install
```
<<<<<<< HEAD
##### 4. Start the Rails server
=======
##### 4. Setup database and migrations
```ruby
  rails db:migrate
```
##### 5. Load seed data
```ruby
  rails db:seed
```
##### 6. Start the Rails server
You can start the rails server using the command given below.
```ruby
bundle exec rails s
```
```
ruby “2.7.1”
rails, “~> 5.2.0"
bootstrap-sass, ‘~> 3.3’, ‘>= 3.3.6’
postgres
activestorag
bootstrap
cloudinary
jquery-rails
pundit

