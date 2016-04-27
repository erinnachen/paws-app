# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
breeds_info = File.read(Rails.root.join('db', 'support','breeds.txt')).chomp.split("\n")
breeds_info.each do |breed|
  id, name = breed.split(", ")
  Breed.find_or_create_by(id: id, name: name)
end

User.create(name: "thedogist")
