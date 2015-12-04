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
    email:                 "test_email@email.com",
    admin:                 true,
    password:              "123456",
    password_confirmation: "123456"
    })
end
