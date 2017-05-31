Role.create({ name: "instructor" })
Role.create({ name: "assistant" })
Role.create({ name: "student" })

user = User.new(fname: "Bowen", password: "password", lname: "Hui", username: "bowenhui@ubc.ca", email: "bowenhui@ubc.ca", instructor: true, studentnumber: 00000000)
user.add_role(:instructor)
user.save