User.create!(name: "Frank Soucy",
		   email: "franksoucy9@gmail.com",
		   password: "sjptj8zX",
		   password_confirmation: "sjptj8zX",
		   admin: true,
                   full_street_address: "01923",
		   activated: true,
		   activated_at: Time.zone.now,
		   public: true)

User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             full_street_address: "01923",
	     admin:true,
	     activated: true,
	     activated_at: Time.zone.now,
	     public: true)


