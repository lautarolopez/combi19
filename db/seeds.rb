# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Delete database before create seeds
Travel.destroy_all
Route.destroy_all
Extra.destroy_all
Combi.destroy_all
City.destroy_all
User.destroy_all

#Create first admin user
if User.find_by(dni: 1) == nil
	admin = User.create(email: "admin@combi19.com", password: "combi19", name: "Admin", last_name: "Admin", dni: 1, birth_date: 50.years.ago, role: "admin", suscribed: false)
end

#Create first suscribed user
if User.find_by(dni: 987) == nil
	admin = User.create(email: "suscribed@combi19.com", password: "suscribed", name: "Suscribed", last_name: "Guy", dni: 987, birth_date: 19.years.ago, role: "user", suscribed: true)
end

#Create drivers
20.times do |i|
	if User.find_by(dni: 1123 * i) == nil
    	User.create(email: "driver#{i}@combi19.com", password: "combi19", name: "Jhon #{i}", last_name: "Driver", dni: 1123 * i, birth_date: 30.years.ago, role: "driver", suscribed: false)
    end
end
driver1 = User.find_by(email: "driver1@combi19.com")
driver2 = User.find_by(email: "driver2@combi19.com")
driver3 = User.find_by(email: "driver3@combi19.com")
driver4 = User.find_by(email: "driver4@combi19.com")
driver5 = User.find_by(email: "driver5@combi19.com")
driver6 = User.find_by(email: "driver6@combi19.com")
driver7 = User.find_by(email: "driver7@combi19.com")
driver8 = User.find_by(email: "driver8@combi19.com")
driver9 = User.find_by(email: "driver9@combi19.com")




# Create extras
coca = Extra.find_or_create_by(name: "coca cola", description: "La mejor gaseosa", price: 80.0)
papas = Extra.find_or_create_by(name: "papas fritas", description: "Papas fritas marca Lays las mejores y más ricas", price: 60.0)
manaos = Extra.find_or_create_by(name: "manaos uva", description: "Gaseosa sabor uva", price: 0.0)
choco = Extra.find_or_create_by(name: "block", description: "chocolate", price: 100.0)
cerveza = Extra.find_or_create_by(name: "cerveza", description: "cerveza Andes", price: 120.0)


# Create cities
la_plata = City.find_or_create_by(name: "la plata", state: "buenos aires")
necochea = City.find_or_create_by(name: "necochea", state: "buenos aires")
rauch = City.find_or_create_by(name: "rauch", state: "buenos aires")
tandil = City.find_or_create_by(name: "tandil", state: "buenos aires")
gualeguaychu = City.find_or_create_by(name: "gualeguaychú", state: "buenos aires")
villa_la_angostura = City.find_or_create_by(name: "villa la angostura", state: "neuquén")
alvear = City.find_or_create_by(name: "general alvear", state: "buenos aires")
chascomus = City.find_or_create_by(name: "chascomus", state: "buenos aires")
posadas = City.find_or_create_by(name: "posadas", state: "misiones")


#Create combis
combi1 = Combi.find_or_create_by(licence_plate: "ABC123", category: "cómoda", capacity: 100)
combi2 = Combi.find_or_create_by(licence_plate: "ABC124", category: "súper cómoda", capacity: 100)
combi3 = Combi.find_or_create_by(licence_plate: "CDE456", category: "cómoda", capacity: 100)
combi4 = Combi.find_or_create_by(licence_plate: "BFS123", category: "súper cómoda", capacity: 100)
combi5 = Combi.find_or_create_by(licence_plate: "QWE123", category: "cómoda", capacity: 100)
combi6 = Combi.find_or_create_by(licence_plate: "QWE124", category: "súper cómoda", capacity: 100)
combi7 = Combi.find_or_create_by(licence_plate: "QWE125", category: "súper cómoda", capacity: 100)
combi8 = Combi.find_or_create_by(licence_plate: "QWE126", category: "súper cómoda", capacity: 100)
combi9 = Combi.find_or_create_by(licence_plate: "QWE127", category: "súper cómoda", capacity: 100)


# Create routes
rauch_laplata = Route.find_or_create_by(origin: rauch, destination: la_plata)
rauch_laplata.extras << coca
rauch_laplata.extras << cerveza
rauch_laplata.extras << papas
rauch_laplata.extras = rauch_laplata.extras.uniq

laplata_tandil = Route.find_or_create_by(origin: la_plata, destination: tandil)
laplata_tandil.extras << coca
laplata_tandil.extras << cerveza
laplata_tandil.extras << papas
laplata_tandil.extras = laplata_tandil.extras.uniq

chascomus_posadas = Route.find_or_create_by(origin: chascomus, destination: posadas)
chascomus_posadas.extras << choco
chascomus_posadas.extras << manaos
chascomus_posadas.extras = chascomus_posadas.extras.uniq

rauch_chascomus = Route.find_or_create_by(origin: rauch, destination: chascomus)
rauch_chascomus.extras << cerveza
rauch_chascomus.extras = rauch_chascomus.extras.uniq

posadas_laplata = Route.find_or_create_by(origin: posadas, destination: la_plata)
posadas_laplata.extras << choco
posadas_laplata.extras << manaos
posadas_laplata.extras = posadas_laplata.extras.uniq

chascomus_laplata = Route.find_or_create_by(origin: chascomus, destination: la_plata)
chascomus_laplata.extras << cerveza
chascomus_laplata.extras = chascomus_laplata.extras.uniq

chascomus_rauch = Route.find_or_create_by(origin: chascomus, destination: rauch)
chascomus_rauch.extras << cerveza
chascomus_rauch.extras = chascomus_rauch.extras.uniq

laplata_villalaangostura = Route.find_or_create_by(origin: la_plata, destination: villa_la_angostura)
laplata_villalaangostura.extras << cerveza
laplata_villalaangostura.extras << coca
laplata_villalaangostura.extras << papas
laplata_villalaangostura.extras << choco
laplata_villalaangostura.extras = laplata_villalaangostura.extras.uniq

villalaangostura_tandil = Route.find_or_create_by(origin: villa_la_angostura, destination: tandil)
villalaangostura_tandil.extras << choco
villalaangostura_tandil.extras << coca
villalaangostura_tandil.extras << papas
villalaangostura_tandil.extras = villalaangostura_tandil.extras.uniq


# Create travels
Travel.find_or_create_by(route: rauch_laplata, date_departure: DateTime.new(2021, 1, 19, 13, 27), date_arrival: DateTime.new(2021, 2, 17, 17, 27), discount: 0, price: 900, driver: driver9, combi: combi1)
Travel.find_or_create_by(route: rauch_laplata, date_departure: DateTime.new(2021, 2, 18, 14), date_arrival: DateTime.new(2021, 3, 18, 14), discount: 0, price: 900, driver: driver8, combi: combi2)
Travel.find_or_create_by(route: laplata_tandil, date_departure: DateTime.new(2021, 3, 19, 15), date_arrival: DateTime.new(2021, 4, 19, 22), discount: 0, price: 900, driver: driver7, combi: combi3)
Travel.find_or_create_by(route: laplata_villalaangostura, date_departure: DateTime.new(2021, 4, 20, 16, 27), date_arrival: DateTime.new(2021, 5, 20, 13, 27), discount: 50, price: 4000, driver: driver6, combi: combi4)
Travel.find_or_create_by(route: villalaangostura_tandil, date_departure: DateTime.new(2021, 5, 21, 17, 27), date_arrival: DateTime.new(2021, 6, 21, 13, 27), discount: 0, price: 4000, driver: driver5, combi: combi5)
Travel.find_or_create_by(route: rauch_laplata, date_departure: DateTime.new(2021, 6, 22, 18), date_arrival: DateTime.new(2021, 7, 22, 14), discount: 30, price: 900, driver: driver4, combi: combi6)
Travel.find_or_create_by(route: chascomus_posadas, date_departure: DateTime.new(2021, 7, 23, 19, 27), date_arrival: DateTime.new(2021, 8, 23, 10, 27), discount: 0, price: 900, driver: driver3, combi: combi7)
Travel.find_or_create_by(route: chascomus_posadas, date_departure: DateTime.new(2021, 8, 24, 20, 27), date_arrival: DateTime.new(2021, 9, 24, 10, 27), discount: 15, price: 900, driver: driver2, combi: combi8)
Travel.find_or_create_by(route: posadas_laplata, date_departure: DateTime.new(2021, 9, 25, 21, 27), date_arrival: DateTime.new(2021, 10, 25, 10, 27), discount: 0, price: 900, driver: driver1, combi: combi9)
