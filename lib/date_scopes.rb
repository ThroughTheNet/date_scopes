require 'active_record'
module DateScopes
  
  module ClassMethods
    def has_date_scopes(options = {})
      options.to_options!.reverse_merge! :column => 'published'
      column_name = "#{options[:column]}_at"
      
      raise "Could not find the #{column_name} column on the #{table_name} table" unless column_names.include? column_name
      
      on_scope_sql = "#{table_name}.#{column_name} <= ?"
      
      un_scope_sql = "#{table_name}.#{column_name} >= ? OR #{table_name}.#{column_name} IS NULL"
      
      scope options[:column], lambda { where(on_scope_sql, Time.now) }
      %w{un non non_ not_}.each do |prefix|
        scope prefix+options[:column].to_s, lambda { where(un_scope_sql, Time.now) }
      end
      
      define_method options[:column].to_s+'=' do |value|
        if value && !self[column_name]
          self[column_name] = Time.now
        elsif !value
          self[column_name] = nil
        end
      end
      
      define_method options[:column] do
        return false unless time = self[column_name]
        time <= Time.now
      end
      alias_method options[:column].to_s+'?', options[:column]
      
    end
  end
  
  private
  
  def self.included(base)
    base.extend(ClassMethods)
  end
  
end

ActiveRecord::Base.send(:include, DateScopes)
