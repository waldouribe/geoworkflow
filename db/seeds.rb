# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.find_or_create_by username: 'munistgo', auth_token: 'TW-0055618-CL', role: 'admin'
User.find_or_create_by username: 'waldouribe', auth_token: 'TW-087211-CL', role: 'member'
User.find_or_create_by username: 'nelsonbaloian', auth_token: 'TW-087211-CL', role: 'member'

ProcessType.find_or_create_by name: 'Remover escombros', hashtag: 'remover_escombros', description: 'Sacamos escombros de cualquier lugar de la comuna de Santiago'
ProcessType.find_or_create_by name: 'Vigilar', hashtag: 'vigilar', description: 'Vigilamos actividad sospechosa en la comuna de Santiago'