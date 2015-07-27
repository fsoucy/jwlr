User.create!(name: "Frank Soucy",
		   email: "franksoucy9@gmail.com",
		   password: "sjptj8zX",
		   password_confirmation: "sjptj8zX",
		   admin: true,
		   activated: true,
		   activated_at: Time.zone.now,
		   public: true)

User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
	     admin:true,
	     activated: true,
	     activated_at: Time.zone.now,
	     public: true)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
	       activated: true,
	       activated_at: Time.zone.now)
end