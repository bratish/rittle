require 'rittle'
module Rittle
  DBH = Mysql.real_connect("localhost", "root", "", "test")
  class Base
    def self.get_somthing(table_name)
      res = DBH.list_fields("#{table_name}")
      m = model_for_table(table_name)
      set_fields(m, res)       
    end
    
    def self.model_for_table(table_name)
      klass = Class.new Base
      model_name = Object.const_set(table_name.capitalize, klass)
    end
    
    def self.set_fields(m, res)
      column_names = res.fetch_fields.collect{|r| r.name}    
      m.instance_eval do
        column_names.each do |cname|
          attr_accessor cname
        end
      end
      return m.new
    end
    
    def insert
      DBH.query("INSERT INTO animal (name, category)
                   VALUES
                     ('#{name}', '#{category}')")
    end
    
    def self.get_value(options = {})      
      conditions = ""      
      options.each_pair do |key, value|
        conditions = conditions + "#{key.to_s} = '#{value}'"
      end      
      res = DBH.query("SELECT * FROM animal where #{conditions}")
      
      fill_value(res)
    end
    
    def self.fill_value(res)
      arr = []
      
      res.each_hash do |row|
        a = self.new
        row.each do |key, value|
          p "'@#{key}',#{value}"
          a.instance_variable_set("@#{key}",value)
        end
        arr << a
      end
      arr
    end
    
  end
end



  
  