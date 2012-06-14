require './base'


animal = Rittle::Base.get_object('animal')

animal.name = "wrong"
animal.category = "wrong"
animal.insert #saves Data into the database

animal1 = Rittle::Base.get_object('animal')
animal1.insert(:name => "Cow", :category => "Good") #saves Data into the database
animals = Animal.get_rows(:category => 'wrong') #get an array of object
Animal.get_row(:category => 'wrong') #get single array of object
animals.first.update_column(:name =>"pet", :category => "DOG") #update all rows matching the conditions
Animal.update_column({:name => "pet"}, {:category => "Labrador"}) #Update all columns matching the conditons
animals.first.remove #remove the row from db for object
Animal.remove(:category => 'Good') #remove all rows matching the conditions
Animal.remove #empty the table

