# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

unless User.any?
  User.create({
    first_name:            "Zac",
    last_name:             "Barnes",
    email:                 "zac.barnes89@gmail.com",
    admin:                 true,
    password:              "123456",
    password_confirmation: "123456"
    })

  User.create({
    first_name:            "Joe",
    last_name:             "Editor",
    email:                 "joe.editor@gmail.com",
    admin:                 false,
    password:              "654321",
    password_confirmation: "654321"
    })
end
