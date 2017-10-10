# Create users
User.create!(email: "example@email.com", password: "password")

15.times do |n|
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(email: email, password: password)
end
