require './base'


profiles = Rittle::Base.get_object('animal')
p profiles.instance_variables
profiles.name = "sssssss"
profiles.category = "aaaaaaaaaaa"
profiles.insert


a = Animal.get_value(:category => 'aaaaaaaaaaa')

p a

a = Animal.get_value(:name => 'sssssss')

p a

a.first.update_column(:name =>"abcd", :category => "DOG")



Testing the changes