# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Delete database before create seeds
#User.destroy_all
#Extra.destroy_all
#Combi.destroy_all
#City.destroy_all
#Route.destroy_all
#Travel.destroy_all

#Create first admin user
user = User.new
user.email = "admin@combi19.com"
user.password = "combi19"
user.name = "Admin"
user.last_name = "Admin"
user.dni = 1
user.birth_date = 50.years.ago 
user.role = "admin"
user.suscribed = false
user.save!

#Create 50 drivers
50.times do |i|
    user = User.new
    user.email = "driver#{i}@combi19.com"
    user.password = "combi19"
    user.name = "Jhon"
    user.last_name = "Driver"
    user.dni = 1123 * i
    user.birth_date = 30.years.ago 
    user.role = "driver"
    user.suscribed = false
    user.save!
end