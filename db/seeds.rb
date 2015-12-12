# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

unless User.any?
  puts "Seeding users..."
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
  puts "Users have been seeded."
end

puts "Seeding categories..."
Category.find_or_create_by(pretty_name: "Business", name: "business")
Category.find_or_create_by(pretty_name: "Personal Finance", name: "personal_finance")
Category.find_or_create_by(pretty_name: "Sales & Marketing", name: "sales_and_marketing")
Category.find_or_create_by(pretty_name: "Career Development", name: "career_development")
Category.find_or_create_by(pretty_name: "Self Improvement", name: "self_improvement")
Category.find_or_create_by(pretty_name: "Health / Fitness", name: "health_fitness")
Category.find_or_create_by(pretty_name: "Science", name: "science")
Category.find_or_create_by(pretty_name: "Spirituality", name: "spirituality")
Category.find_or_create_by(pretty_name: "Sports", name: "sports")
Category.find_or_create_by(pretty_name: "Technology", name: "technology")
Category.find_or_create_by(pretty_name: "Memoir", name: "memoir")
Category.find_or_create_by(pretty_name: "Miscellaneous", name: "miscellaneous")
puts "Categories have been seeded."
