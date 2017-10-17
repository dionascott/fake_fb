require 'faker'
# Create users
User.create!(email: "example@email.com", password: "password", name: Faker::HarryPotter.character)

15.times do |n|
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(email: email, password: password, name: Faker::HarryPotter.character)
end

16.times do |n|
 User.find(n+1).posts.create!(content: Faker::HarryPotter.quote, created_at: Faker::Time.between(DateTime.now - 10, DateTime.now))
 User.find(n+1).posts.create!(content: Faker::HarryPotter.quote, created_at: Faker::Time.between(DateTime.now - 10, DateTime.now))
end
5.times do |n|
  User.find(1).invite(User.find(n+2))
end

5.times do |n|
  User.find(n+7).invite(User.find(1))
end

User.find(3).approve(User.find(1))
User.find(4).approve(User.find(1))
User.find(1).approve(User.find(8))
User.find(1).approve(User.find(9))
