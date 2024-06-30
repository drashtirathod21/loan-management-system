# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.create(name: 'Admin User', email: 'admin@mail.com', password: 'admin@123', password_confirmation: 'admin@123', role: 1)
User.create(name: 'ABC User', email: 'abc@mail.com', password: 'abc@123', password_confirmation: 'abc@123', role: 0)
