# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# boolean value is defaulted to false, but can be good to define in case
if User.count == 0
    User.create(username: "jacqui", email: "jacqui@email.com", password: "password1", password_confirmation: "password1", is_admin: true)
    User.create(username: "kim", email: "kim@email.com", password: "password2", password_confirmation: "password2", is_admin: false)
end


if Message.count == 0
    Message.create(text: "So use to manually setting it all up haha", user_id: 1)
    Message.create(text: "This is scaffolding magic?", user_id: 2)
    Message.create(text: "A bit rusty with Rails now but why are they not explicitly displayed in the routers file?", user_id: 2)
end