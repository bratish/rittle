require 'rubygems'
require 'littr'

m = Mysql.new("localhost", "root", "", "solaro_development")
res = m.query("select id, gender from profiles")
p res
res.each{|r| p r}
