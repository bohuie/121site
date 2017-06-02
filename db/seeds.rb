Role.create({ name: "instructor" })
Role.create({ name: "assistant" })
Role.create({ name: "student" })

user = User.new(fname: "Prof", password: "password", lname: "Instructor", username: "john@doe.ca", email: "john@doe.ca", instructor: true, studentnumber: 00000000)
user.add_role(:instructor)
user.save

user.teach_courses.build(title: "Programming 1", subject: "Cosc 111", year: "2016")
user.teach_courses.build(title: "Programming 1", subject: "Cosc 111", year: "2015")
user.teach_courses.build(title: "Programming 2", subject: "Cosc 121", year: "2015")
user.save

student1 = User.new(fname: "Tyler", lname: "Finley", password: "password", username: "Tyler@Finley.com", email: "Tyler@Finley.com", studentnumber: 11111111)
student1.save
student2 = User.new(fname: "Mackena", lname: "Carroll", password: "password", username: "Mackena@Carroll.com", email: "Mackena@Carroll.com", studentnumber: 22222222)
student2.save
student3 = User.new(fname: "Kaden", lname: "Buchanan", password: "password", username: "Kaden@Buchanan.com", email: "Kaden@Buchanan.com", studentnumber: 33333333)
student3.save
student4 = User.new(fname: "Mackena", lname: "Finley", password: "password", username: "Mackena@Finley.com", email: "Mackena@Finley.com", studentnumber: 44444444)
student4.save
student5 = User.new(fname: "Lenzy", lname: "Bennett", password: "password", username: "Lenzy@Bennett.com", email: "Lenzy@Bennett.com", studentnumber: 55555555)
student5.save
student6 = User.new(fname: "Derryne", lname: "Keith", password: "password", username: "Derryne@Keith.com", email: "Derryne@Keith.com", studentnumber: 66666666)
student6.save

c1 = Course.find(1)
c1.labs.build(name: "L01")
c1.labs.build(name: "L02")
c1.labs.build(name: "L03")
c1.save

c2 = Course.find(2)
c2.labs.build(name: "L01")
c2.labs.build(name: "L02")
c2.labs.build(name: "L03")
c2.save

c3 = Course.find(3)
c3.labs.build(name: "L01")
c3.labs.build(name: "L02")
c3.labs.build(name: "L03")
c3.save

student1.courses << c1
student1.labs << Lab.find(1)
student1.courses << c2
student1.labs << Lab.find(4)

student2.courses << c1
student2.labs << Lab.find(1)
student2.courses << c3
student2.labs << Lab.find(7)

student3.courses << c1
student3.labs << Lab.find(2)
student3.courses << c2
student3.labs << Lab.find(4)

student4.courses << c1
student4.labs << Lab.find(2)
student4.courses << c2
student4.labs << Lab.find(5)

student5.courses << c1
student5.labs << Lab.find(3)
student5.courses << c3
student5.labs << Lab.find(7)

student6.courses << c1
student6.labs << Lab.find(3)
student6.courses << c3
student6.labs << Lab.find(8)
