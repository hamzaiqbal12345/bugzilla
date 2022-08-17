# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
if Rails.env.development?
  manager1 = User.find_or_create_by!(email: 'manager1@gmail.com') do |user|
    user.name = 'manager1'
    user.password = '123456'
    user.password_confirmation = '123456'
    user.role = 'manager'
  end
end
manager1.skip_confirmation!
manager1.save!

if Rails.env.development?
  developer1 = User.find_or_create_by!(email: 'developer1@gmail.com') do |user|
    user.name = 'developer1'
    user.password = '123456'
    user.password_confirmation = '123456'
    user.role = 'developer'
  end
end
developer1.skip_confirmation!
developer1.save!

if Rails.env.development?
  qa1 = User.find_or_create_by!(email: 'qa1@gmail.com') do |user|
    user.name = 'qa1'
    user.password = '123456'
    user.password_confirmation = '123456'
    user.role = 'qa'
  end
end
qa1.skip_confirmation!
qa1.save!

project1 = Project.create(title: 'facebook', description: 'connecting people', creator_id: manager1.id)
project2 = Project.create(title: 'Instagram', description: 'Photo sharing app', creator_id: manager1.id)
project3 = Project.create(title: 'Tik tok', description: 'cringe content application', creator_id: manager1.id)

UsersProject.create(user_id: manager1.id, project_id: project1.id)
UsersProject.create(user_id: manager1.id, project_id: project2.id)
UsersProject.create(user_id: manager1.id, project_id: project3.id)

Bug.create(title: 'project1_bug1', description: 'heroku problem', deadline: Time.strptime('06/30/2012 00:00', '%m/%d/%Y %H:%M'), bug_type: 'bug', status: 'neew',
           project_id: project1.id, posted_by_id: qa1.id)
Bug.create(title: 'project1_bug2', description: 'deployment problem', deadline: Time.strptime('06/30/2012 00:00', '%m/%d/%Y %H:%M'), bug_type: 'bug', status: 'neew',
           project_id: project1.id, posted_by_id: qa1.id)
Bug.create(title: 'project2_bug1', description: 'layout problem', deadline: Time.strptime('06/30/2012 00:00', '%m/%d/%Y %H:%M'), bug_type: 'bug', status: 'neew',
           project_id: project2.id, posted_by_id: qa1.id)
