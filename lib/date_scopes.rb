require 'active_record'

module DateScopes
  
  module ClassMethods
  
    # Adds a number of dynamic scopes and a virtual accessor to your model.
    # Functionality is detailed more fully in the {file:README.markdown README} for this gem, but a brief demo is given here:
    # @example
    #    class Post < ActiveRecord::Base
    #      has_date_scopes
    #    end
    #
    #    Post.published                  #posts with published_at before Time.now
    #    Post.unpublished                #posts with published_at after Time.now
    #    post = Post.new
    #    post.published = true           #virtual setter, sets published_at to Time.now
    #    post.published_at == Time.now   #true
    #    post.published? == true         #true
    #    post.published = false          #virtual setter, sets published_at to nil
    #    post.published_at.nil?          #true
    # @param [Hash] opts The options
    # @option opts [Symbol, String] :column The verb that will be used to form the names of the scopes, and corresponds to a database column (if :column is `deleted` then there must be a database column `deleted_at`.) Defaults to `published` and a corresponding database column `published_at`
    # @raise [ActiveRecordError] An exception will be raised if the required column is not present, telling you the name of the column it expects.

    def has_date_scopes(options = {})
      options.to_options!.reverse_merge! :column => 'published'
      column_name = "#{options[:column]}_at"
      
      raise ActiveRecord::ActiveRecordError, "Could not find the #{column_name} column on the #{table_name} table" unless column_names.include? column_name
      
      on_scope_sql = "#{table_name}.#{column_name} <= ?"
      
      un_scope_sql = "#{table_name}.#{column_name} >= ? OR #{table_name}.#{column_name} IS NULL"
      
      scope options[:column], lambda { where(on_scope_sql, Time.now) }
      %w{un non non_ not_}.each do |prefix|
        scope prefix+options[:column].to_s, lambda { where(un_scope_sql, Time.now) }
      end
      
      define_method options[:column].to_s+'=' do |value|
        value = %w{true 1}.include? value.downcase if value.is_a? String
        value = value == 1 if value.is_a? Fixnum
        
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
