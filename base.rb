require './rittle'
module Rittle
  DBH = Mysql.real_connect("localhost", "root", "", "test")
  class Base
    def self.get_object(table_name)
      m = model_for_table(table_name)
      res = DBH.list_fields("#{table_name}")
      set_fields(m, res)
    end
    
    def self.model_for_table(table_name)
      klass = Class.new Base
      model_name = get_model_name(table_name)
      model_name = Object.const_set(model_name.capitalize, klass)
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
    
    def insert(options = {})
      values_and_columns = get_columns_and_values(options)
      DBH.query("INSERT INTO #{get_table_name} (#{values_and_columns.keys.join(',')})
                   VALUES
                     (#{values_and_columns.values.join(',')})")
    end
    
    def update_column(to_update)
      update_string = []
      to_update.each do |key, value|
        instance_variable_set("@#{key}",value)
        update_string << "#{key} = '#{value}'"
      end
      DBH.query("UPDATE #{get_table_name} SET #{update_string.join(', ')} where id=#{id}")      
    end
    
    def self.update_column(condition = {}, options = {})
      update_string = []
      options.each do |key, value|
        instance_variable_set("@#{key}",value)
        update_string << "#{key} = '#{value}'"
      end
      DBH.query("UPDATE #{self.new.get_table_name} SET #{update_string.join(', ')} #{self.build_conditions(condition)}")      
    end
    
    def get_columns_and_values(options)
      calumn_values = {} 
      column_values = instance_variables.inject({}){|column_values, iv| column_values.merge!(iv.to_s.gsub("@", "").to_sym => "'#{instance_variable_get(iv)}'")}
      opt = {}
      options.each do |key, value|
        opt[key] = "'#{value}'" 
      end
      column_values.merge!(opt)
    end
    
    def self.get_row(options = {}) 
      get_rows(options).first
    end
    
    def self.get_rows(options = {})
      res = DBH.query("SELECT * FROM #{new.get_table_name} #{self.build_conditions(options)}")
      fill_value(res)
    end
    
    def get_table_name
      word = self.class.to_s.dup
      word.gsub!(/::/, '/')
      word.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
      word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
      word.tr!("-", "_")
      word.downcase!
      word
    end
    
    def remove
      DBH.query("Delete from #{get_table_name} where id=#{id}")
    end
    
    def self.remove(options = {})      
      DBH.query("Delete from #{new.get_table_name} #{build_conditions(options)}")
    end
    
    def self.fill_value(res)
      arr = []      
      res.each_hash do |row|
        a = self.new
        row.each do |key, value|
          a.instance_variable_set("@#{key}",value)
        end
        arr << a
      end
      arr
    end
    
    def self.get_model_name(table_name)
      DBH.list_tables(table_name).size ? table_name.split("_").map{|x| x.capitalize}.join : "#{table_name.split("_").map{|x| x.capitalize}.join}s"     
    end
    
    def self.build_conditions(options)
      where = ""
      conditions = []
      unless options.empty?
        where  = "Where"
        options.each do |key, value|
          conditions << "#{key}='#{value}'"
        end
      end
      return "#{where} #{conditions.join(' and ')}"
    end
  end  
end



  
