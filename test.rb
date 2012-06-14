require './base'


profiles = Rittle::Base.get_object('animal')
p profiles.instance_variables
profiles.name = "sssssss"
profiles.category = "aaaaaaaaaaa"
profiles.insert


a = Animal.get_rows(:category => 'aaaaaaaaaaa', :aaa => "eeee")

p a

a = Animal.get_row(:category => 'aaaaaaaaaaa', :aaa => "eeee")

a.first.update_column(:name =>"abcd", :category => "DOG")

a.first.remove
Animal.remove

