# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Delete database before create seeds
Comment.destroy_all
Ticket.destroy_all
Travel.destroy_all
Route.destroy_all
Extra.destroy_all
Combi.destroy_all
City.destroy_all
User.destroy_all
PaymentMethod.destroy_all

#Create first admin user
if User.find_by(dni: 1) == nil
	admin = User.create(email: "admin@combi19.com", password: "combi19", name: "Admin", last_name: "Admin", dni: 1, birth_date: 50.years.ago, role: "admin", subscribed: false)
end

#Create first subscribed user
if User.find_by(dni: 987) == nil
	subscribed = User.create(email: "subscribed@combi19.com", password: "combi19", name: "Subscribed", last_name: "Guy", dni: 987, birth_date: 19.years.ago, role: "user", subscribed: true)
end

# Create subscription payment method and set it to de subscribed user
subscription_payment_method = PaymentMethod.find_or_create_by(card_number: 4567456745674567, name: 'Subscribed Guy', expire_month: 1, expire_year: Date.today.year + 5, company: 'Visa', verification_code: 123, user:subscribed)
subscribed.update(subscription_payment_method_id: subscription_payment_method.id)


# Create drivers
10.times do |i|
	if User.find_by(dni: 1123 * i) == nil
    	User.create(email: "driver#{i}@combi19.com", password: "combi19", name: "John #{i}", last_name: "Driver", dni: 1123 * i, birth_date: 30.years.ago, role: "driver", subscribed: false)
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

# Create simple users
15.times do |i|
	if User.find_by(dni: 1123 * (i+10)) == nil
    	User.create(email: "user#{i}@combi19.com", password: "combi19", name: "Michael #{i}", last_name: "User", dni: 1123 * (i+10), birth_date: 25.years.ago, role: "user", subscribed: false)
    end
end
user1 = User.find_by(email: "user1@combi19.com")
user2 = User.find_by(email: "user2@combi19.com")
user3 = User.find_by(email: "user3@combi19.com")
user4 = User.find_by(email: "user4@combi19.com")
user5 = User.find_by(email: "user5@combi19.com")
user6 = User.find_by(email: "user6@combi19.com")
user7 = User.find_by(email: "user7@combi19.com")
user8 = User.find_by(email: "user8@combi19.com")
user9 = User.find_by(email: "user9@combi19.com")

# Set covid synthoms to users
user1.update(discharge_date: Date.today + 15.days)
user7.update(discharge_date: Date.today + 10.days)
user8.update(discharge_date: Date.today + 5.days)
user9.update(discharge_date: Date.today)

# Create user with real email
email_user = User.create(email: "temporaryemail@combi19.com", password: "combi19", name: "Temporary", last_name: "User", dni: 1123*30, birth_date: 25.years.ago, role: "user", subscribed: false)


# Create payment methods
payment_method1 = PaymentMethod.find_or_create_by(card_number: 4444444444441111, name: user1.name + ' ' + user1.last_name, expire_month: 1, expire_year: Date.today.year + 5, company: 'Visa', verification_code: 123, user: user1)
payment_method2 = PaymentMethod.find_or_create_by(card_number: 4444444444442222, name: user2.name + ' ' + user2.last_name, expire_month: 1, expire_year: Date.today.year + 5, company: 'Mastercard', verification_code: 123, user: user2)
payment_method3 = PaymentMethod.find_or_create_by(card_number: 4444444444443333, name: user3.name + ' ' + user3.last_name, expire_month: 1, expire_year: Date.today.year + 5, company: 'American Express', verification_code: 123, user: user3)
payment_method4 = PaymentMethod.find_or_create_by(card_number: 4444444444444444, name: user4.name + ' ' + user4.last_name, expire_month: 1, expire_year: Date.today.year + 5, company: 'Visa', verification_code: 123, user: user4)
payment_method5 = PaymentMethod.find_or_create_by(card_number: 4444444444445555, name: user5.name + ' ' + user5.last_name, expire_month: 1, expire_year: Date.today.year + 5, company: 'Visa', verification_code: 123, user: user5)
payment_method6 = PaymentMethod.find_or_create_by(card_number: 4444444444446666, name: user6.name + ' ' + user6.last_name, expire_month: 1, expire_year: Date.today.year + 5, company: 'Visa', verification_code: 123, user: user6)
without_founds1 = PaymentMethod.find_or_create_by(card_number: 4444444444441119, name: user1.name + ' ' + user1.last_name, expire_month: 1, expire_year: Date.today.year + 5, company: 'Mastercard', verification_code: 123, user: user1)
without_founds2 = PaymentMethod.find_or_create_by(card_number: 4444444444442229, name: user2.name + ' ' + user2.last_name, expire_month: 1, expire_year: Date.today.year + 5, company: 'American Express', verification_code: 123, user: user2)
without_founds3 = PaymentMethod.find_or_create_by(card_number: 4444444444443339, name: user3.name + ' ' + user3.last_name, expire_month: 1, expire_year: Date.today.year + 5, company: 'Visa', verification_code: 123, user: user3)
without_founds4 = PaymentMethod.find_or_create_by(card_number: 4444444444444449, name: user4.name + ' ' + user4.last_name, expire_month: 1, expire_year: Date.today.year + 5, company: 'Mastercard', verification_code: 123, user: user4)
payment_methodS = PaymentMethod.find_or_create_by(card_number: 4321432143214321, name: 'Subscribed Guy', expire_month: 1, expire_year: Date.today.year + 5, company: 'Mastercard', verification_code: 123, user: subscribed)
without_foundsS = PaymentMethod.find_or_create_by(card_number: 456745674567456789, name: 'Subscribed Guy', expire_month: 1, expire_year: Date.today.year + 5, company: 'American Express', verification_code: 123, user: subscribed)
payment_methodE = PaymentMethod.find_or_create_by(card_number: 5444444444442222, name: email_user.name + ' ' + email_user.last_name, expire_month: 1, expire_year: Date.today.year + 5, company: 'Mastercard', verification_code: 123, user: email_user)
without_foundsE = PaymentMethod.find_or_create_by(card_number: 5444444444442229, name: email_user.name + ' ' + email_user.last_name, expire_month: 1, expire_year: Date.today.year + 5, company: 'American Express', verification_code: 123, user: email_user)


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

posadas_laplata = Route.find_or_create_by(origin: posadas, destination: la_plata)
posadas_laplata.extras << choco
posadas_laplata.extras << manaos
posadas_laplata.extras = posadas_laplata.extras.uniq

chascomus_laplata = Route.find_or_create_by(origin: chascomus, destination: la_plata)
chascomus_laplata.extras << cerveza
chascomus_laplata.extras = chascomus_laplata.extras.uniq

chascomus_rauch = Route.find_or_create_by(origin: chascomus, destination: rauch)

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


# Create previous travels
previous_travel1 = Travel.find_or_create_by(route: rauch_laplata, date_departure: (DateTime.now - 1.months), date_arrival: (DateTime.now - 1.months + 4.hours), price: 900, driver: driver1, combi: combi1)
previous_travel2 = Travel.find_or_create_by(route: rauch_laplata, date_departure: (DateTime.now - 2.months), date_arrival: (DateTime.now - 2.months + 4.hours), price: 900, driver: driver1, combi: combi1)
previous_travel3 = Travel.find_or_create_by(route: laplata_tandil, date_departure: (DateTime.now - 3.months), date_arrival: (DateTime.now - 3.months + 4.hours), price: 900, driver: driver1, combi: combi1)
previous_travel4 = Travel.find_or_create_by(route: laplata_villalaangostura, date_departure: (DateTime.now - 4.months), date_arrival: (DateTime.now - 4.months + 1.days), price: 4000, driver: driver2, combi: combi2)
previous_travel5 = Travel.find_or_create_by(route: villalaangostura_tandil, date_departure: (DateTime.now - 5.months), date_arrival: (DateTime.now - 5.months + 1.days), price: 4000, driver: driver3, combi: combi3)
previous_travel6 = Travel.find_or_create_by(route: rauch_laplata, date_departure: (DateTime.now - 6.months), date_arrival: (DateTime.now - 6.months + 4.hours), price: 900, driver: driver1, combi: combi1)
previous_travel7 = Travel.find_or_create_by(route: chascomus_posadas, date_departure: (DateTime.now - 7.months), date_arrival: (DateTime.now - 7.months + 9.hours), price: 900, driver: driver4, combi: combi4)
previous_travel8 = Travel.find_or_create_by(route: chascomus_posadas, date_departure: (DateTime.now - 8.months), date_arrival: (DateTime.now - 7.months + 9.hours), price: 900, driver: driver5, combi: combi5)
previous_travel9 = Travel.find_or_create_by(route: posadas_laplata, date_departure: (DateTime.now - 9.months), date_arrival: (DateTime.now - 9.months + 9.hours), price: 900, driver: driver5, combi: combi5)

# Create current travels
current_travel1 = Travel.find_or_create_by(route: rauch_laplata, date_departure: (DateTime.now), date_arrival: (DateTime.now + 5.hours), price: 900, discount: 0, driver: driver1, combi: combi1)
current_travel2 = Travel.find_or_create_by(route: laplata_tandil, date_departure: (DateTime.now), date_arrival: (DateTime.now + 4.hours), price: 900, discount: 0, driver: driver2, combi: combi2)
current_travel3 = Travel.find_or_create_by(route: laplata_villalaangostura, date_departure: (DateTime.now), date_arrival: (DateTime.now + 1.days), price: 4000, discount: 50, driver: driver3, combi: combi3)
current_travel4 = Travel.find_or_create_by(route: villalaangostura_tandil, date_departure: (DateTime.now), date_arrival: (DateTime.now + 15.days + 1.days), price: 4000, discount: 0, driver: driver4, combi: combi4)
current_travel5 = Travel.find_or_create_by(route: chascomus_posadas, date_departure: (DateTime.now), date_arrival: (DateTime.now + 9.hours), price: 900, discount: 0, driver: driver5, combi: combi5)
current_travel6 = Travel.find_or_create_by(route: posadas_laplata, date_departure: (DateTime.now), date_arrival: (DateTime.now + 9.hours), price: 900, discount: 0, driver: driver6, combi: combi6)

# Create future travels
future_travel1 = Travel.find_or_create_by(route: rauch_laplata, date_departure: (DateTime.now + 12.hours), date_arrival: (DateTime.now + 17.hours), price: 900, discount: 0, driver: driver1, combi: combi1)
future_travel2 = Travel.find_or_create_by(route: rauch_chascomus, date_departure: (DateTime.now + 2.days), date_arrival: (DateTime.now + 2.days + 4.hours), price: 900, discount: 25, driver: driver1, combi: combi1)
future_travel3 = Travel.find_or_create_by(route: laplata_tandil, date_departure: (DateTime.now + 5.days), date_arrival: (DateTime.now + 5.days + 4.hours), price: 900, discount: 0, driver: driver8, combi: combi1)
future_travel4 = Travel.find_or_create_by(route: laplata_villalaangostura, date_departure: (DateTime.now + 10.days), date_arrival: (DateTime.now + 10.days + 1.days), price: 4000, discount: 50, driver: driver2, combi: combi2)
future_travel5 = Travel.find_or_create_by(route: villalaangostura_tandil, date_departure: (DateTime.now + 15.days), date_arrival: (DateTime.now + 15.days + 1.days), price: 4000, discount: 0, driver: driver3, combi: combi3)
future_travel6 = Travel.find_or_create_by(route: rauch_laplata, date_departure: (DateTime.now + 20.days), date_arrival: (DateTime.now + 20.days + 4.hours), price: 900, discount: 30, driver: driver7, combi: combi1)
future_travel7 = Travel.find_or_create_by(route: chascomus_posadas, date_departure: (DateTime.now + 1.months), date_arrival: (DateTime.now + 1.months + 9.hours), price: 900, discount: 0, driver: driver4, combi: combi4)
future_travel8 = Travel.find_or_create_by(route: chascomus_rauch, date_departure: (DateTime.now + 2.months), date_arrival: (DateTime.now + 2.months + 9.hours), price: 900, discount: 15, driver: driver5, combi: combi5)
future_travel9 = Travel.find_or_create_by(route: posadas_laplata, date_departure: (DateTime.now + 3.months), date_arrival: (DateTime.now + 3.months + 9.hours), price: 900, discount: 0, driver: driver5, combi: combi5)

## Create recurrent travel
time = 15.days
while (DateTime.now + time < DateTime.now + 2.months + 15.days)
	Travel.find_or_create_by(route: laplata_villalaangostura, date_departure: (DateTime.now  + time), date_arrival: (DateTime.now + time + 1.days), price: 4000, discount: 50, driver: driver7, combi: combi7, recurrence: :week, recurrence_name: "Semanal verano")
	time = time + 1.week
end


# Create previous tickets
Ticket.find_or_create_by(travel: previous_travel1, user: user1, price: previous_travel1.price, status: :confirmed)
Ticket.find_or_create_by(travel: previous_travel1, user: user2, price: previous_travel1.price, status: :confirmed)
Ticket.find_or_create_by(travel: previous_travel1, user: user3, price: previous_travel1.price, status: :rejected)
Ticket.find_or_create_by(travel: previous_travel1, user: user4, price: previous_travel1.price, status: :confirmed)
Ticket.find_or_create_by(travel: previous_travel1, user: email_user, price: previous_travel1.price, status: :confirmed)
Ticket.find_or_create_by(travel: previous_travel1, user: subscribed, price: previous_travel1.price*(1-previous_travel1.discount/100.0), status: :confirmed)
Ticket.find_or_create_by(travel: previous_travel2, user: user2, price: previous_travel2.price, status: :confirmed)
Ticket.find_or_create_by(travel: previous_travel2, user: user3, price: previous_travel2.price, status: :confirmed)
Ticket.find_or_create_by(travel: previous_travel2, user: user4, price: previous_travel2.price, status: :confirmed)
Ticket.find_or_create_by(travel: previous_travel2, user: email_user, price: previous_travel2.price, status: :confirmed)
Ticket.find_or_create_by(travel: previous_travel2, user: subscribed, price: previous_travel2.price*(1-previous_travel2.discount/100.0), status: :confirmed)
Ticket.find_or_create_by(travel: previous_travel3, user: user3, price: previous_travel3.price, status: :confirmed)
Ticket.find_or_create_by(travel: previous_travel3, user: user4, price: previous_travel3.price, status: :absent)
Ticket.find_or_create_by(travel: previous_travel3, user: subscribed, price: previous_travel3.price*(1-previous_travel3.discount/100.0), status: :confirmed)
Ticket.find_or_create_by(travel: previous_travel4, user: user4, price: previous_travel4.price, status: :confirmed)
Ticket.find_or_create_by(travel: previous_travel4, user: subscribed, price: previous_travel4.price*(1-previous_travel4.discount/100.0), status: :confirmed)
Ticket.find_or_create_by(travel: previous_travel5, user: user1, price: previous_travel5.price, status: :confirmed)
Ticket.find_or_create_by(travel: previous_travel5, user: user5, price: previous_travel5.price, status: :confirmed)
Ticket.find_or_create_by(travel: previous_travel6, user: user6, price: previous_travel6.price, status: :absent)
Ticket.find_or_create_by(travel: previous_travel7, user: user7, price: previous_travel7.price, status: :rejected)
Ticket.find_or_create_by(travel: previous_travel8, user: user8, price: previous_travel8.price, status: :confirmed)
Ticket.find_or_create_by(travel: previous_travel9, user: user9, price: previous_travel9.price, status: :confirmed)

# Create current tickets
Ticket.find_or_create_by(travel: current_travel1, user: user1, price: future_travel1.price, status: :rejected)
Ticket.find_or_create_by(travel: current_travel1, user: user2, price: future_travel1.price, status: :confirmed)
Ticket.find_or_create_by(travel: current_travel1, user: email_user, price: future_travel1.price, status: :confirmed)
Ticket.find_or_create_by(travel: current_travel1, user: subscribed, price: future_travel1.price*(1-future_travel1.discount/100.0), status: :confirmed)
Ticket.find_or_create_by(travel: current_travel2, user: user3, price: future_travel2.price, status: :confirmed)
Ticket.find_or_create_by(travel: current_travel2, user: user4, price: future_travel2.price, status: :absent)
Ticket.find_or_create_by(travel: current_travel2, user: subscribed, price: future_travel2.price*(1-future_travel2.discount/100.0), status: :confirmed)
Ticket.find_or_create_by(travel: current_travel3, user: user3, price: future_travel3.price, status: :confirmed)
Ticket.find_or_create_by(travel: current_travel3, user: user4, price: future_travel3.price, status: :confirmed)
Ticket.find_or_create_by(travel: current_travel3, user: subscribed, price: future_travel3.price*(1-future_travel3.discount/100.0), status: :confirmed)
Ticket.find_or_create_by(travel: current_travel4, user: user5, price: future_travel4.price, status: :rejected)
Ticket.find_or_create_by(travel: current_travel5, user: user6, price: future_travel5.price, status: :confirmed)

# Create future tickets
Ticket.find_or_create_by(travel: future_travel1, user: user2, price: future_travel1.price)
Ticket.find_or_create_by(travel: future_travel1, user: user3, price: future_travel1.price)
Ticket.find_or_create_by(travel: future_travel1, user: user4, price: future_travel1.price)
Ticket.find_or_create_by(travel: future_travel1, user: email_user, price: future_travel1.price)
Ticket.find_or_create_by(travel: future_travel1, user: subscribed, price: future_travel1.price*(1-future_travel1.discount/100.0))
Ticket.find_or_create_by(travel: future_travel2, user: user2, price: future_travel2.price)
Ticket.find_or_create_by(travel: future_travel2, user: user3, price: future_travel2.price)
Ticket.find_or_create_by(travel: future_travel2, user: user4, price: future_travel2.price)
Ticket.find_or_create_by(travel: future_travel2, user: email_user, price: future_travel2.price)
Ticket.find_or_create_by(travel: future_travel2, user: subscribed, price: future_travel2.price*(1-future_travel2.discount/100.0))
Ticket.find_or_create_by(travel: future_travel3, user: user3, price: future_travel3.price)
Ticket.find_or_create_by(travel: future_travel3, user: user4, price: future_travel3.price)
Ticket.find_or_create_by(travel: future_travel3, user: subscribed, price: future_travel3.price*(1-future_travel3.discount/100.0))
Ticket.find_or_create_by(travel: future_travel4, user: user4, price: future_travel4.price)
Ticket.find_or_create_by(travel: future_travel5, user: user1, price: future_travel5.price)
Ticket.find_or_create_by(travel: future_travel5, user: user5, price: future_travel5.price)
Ticket.find_or_create_by(travel: future_travel6, user: user6, price: future_travel6.price)
Ticket.find_or_create_by(travel: future_travel7, user: user7, price: future_travel7.price)
Ticket.find_or_create_by(travel: future_travel8, user: user1, price: future_travel8.price)
Ticket.find_or_create_by(travel: future_travel8, user: user8, price: future_travel8.price)
Ticket.find_or_create_by(travel: future_travel9, user: user1, price: future_travel9.price)
Ticket.find_or_create_by(travel: future_travel9, user: user9, price: future_travel9.price)
Ticket.find_or_create_by(travel: future_travel9, user: subscribed, price: future_travel9.price*(1-future_travel9.discount/100.0))

# Simulate sold out tickets
free = future_travel2.combi.capacity - future_travel2.occupied
free.times do |i|
	Ticket.create(travel: future_travel2, user: admin, price: future_travel2.price)
end

free = future_travel5.combi.capacity - future_travel5.occupied
free.times do |i|
	Ticket.create(travel: future_travel5, user: admin, price: future_travel5.price)
end

free = future_travel9.combi.capacity - future_travel9.occupied
free.times do |i|
	Ticket.create(travel: future_travel9, user: admin, price: future_travel9.price)
end


# Create comments
Comment.find_or_create_by(text: "Comentario #{user1.name_last_name}", travel: previous_travel1, user:user1)
Comment.find_or_create_by(text: "Comentario #{user2.name_last_name}", travel: previous_travel1, user:user2)
Comment.find_or_create_by(text: "Comentario #{user3.name_last_name}", travel: previous_travel1, user:user3)
Comment.find_or_create_by(text: "Comentario #{user4.name_last_name}", travel: previous_travel1, user:user4)
Comment.find_or_create_by(text: "Comentario #{email_user.name_last_name}", travel: previous_travel1, user:email_user)
Comment.find_or_create_by(text: "Comentario #{subscribed.name_last_name}", travel: previous_travel1, user:subscribed)
Comment.find_or_create_by(text: "Comentario #{user2.name_last_name}", travel: previous_travel2, user:user2)
Comment.find_or_create_by(text: "Comentario #{user3.name_last_name}", travel: previous_travel2, user:user3)
Comment.find_or_create_by(text: "Comentario #{user4.name_last_name}", travel: previous_travel2, user:user4)
Comment.find_or_create_by(text: "Comentario #{email_user.name_last_name}", travel: previous_travel2, user:email_user)
Comment.find_or_create_by(text: "Comentario #{subscribed.name_last_name}", travel: previous_travel2, user:subscribed)
Comment.find_or_create_by(text: "Comentario #{user1.name_last_name}", travel: previous_travel2, user:user1)
Comment.find_or_create_by(text: "Comentario #{user1.name_last_name}", travel: previous_travel2, user:user1)
Comment.find_or_create_by(text: "Comentario #{user1.name_last_name}", travel: previous_travel3, user:user3)
Comment.find_or_create_by(text: "Comentario #{user1.name_last_name}", travel: previous_travel4, user:user4)

