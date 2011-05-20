
require 'base'

profiles = Rittle::Base.get_somthing('animal')

p profiles.instance_variables
profiles.name = "sssssss"
profiles.category = "aaaaaaaaaaa"
profiles.insert


a = Animal.get_value(:category => 'aaaaaaaaaaa')



