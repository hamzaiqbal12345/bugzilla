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

System Dependencies

Rails 5.2.0
ruby 2.7.0
pg >= 0.18', '< 2.0'
Services

Action Mailer

Cloudinary DB

DB used: Postgress

Gems used

gem 'devise'
gem 'bootstrap', '~> 4.2.1'
gem 'jquery-rails'
gem 'pundit'
gem 'bootsnap', '>= 1.1.0'
gem 'pg', '>= 0.18', '< 2.0'
How to use

Clone this repo
Go to project Directory
get master key of project and set it as config:set RAILS_MASTER_KEY='*******'
create following variables and set credetials of cloudinary. cloud_name,api_key,api_secret and CLOUDINARY_URL
create following varibles and set credetials of gmail for sending mail. MAIL_USERNAME: 'abc.xyz@gmail.com' MAIL_PASSWORD: '******'
Do Bundle install
DO rails db:migrate rails db:setup
DO db:seed
start server with rails s
App is running
