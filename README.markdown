#Date_Scopes - an ActiveRecord extension for automatic date-based scopes

**Homepage/Github**:  [github.com/ThroughTheNet/date_scopes](https://github.com/ThroughTheNet/date_scopes)  
**Author**:           Jonathan Davies ([ThroughTheNet](http://throughthnet.com))  
**Contact**:          [info@throughthenet.com](mailto:info@throughthenet.com)  
**License**:          [MIT License](http://opensource.org/licenses/mit-license.php)  
**Version**:          0.1  
**Released**:         December 2nd 2010

##Description


Date_Scopes is a rubygem that adds a simple macro, {DateScopes::ClassMethods#has_date_scopes has_date_scopes} to ActiveRecord. When used it adds a number of convinience scopes to your models relating to a whether a particular date field on that model is in the past or future. It also has other handy features.

Note that it does *not* depend on the whole of Rails, but is a pure ActiveRecord extension. As such it can be used wherever you use ActiveRecord, be it in Sinatra or whatever other mad thing you've cooked up.

##Example Use Case

Say you have a model `Post` in your blog app. You want to be able to write your posts and save them, but not have them appear on the site until a certain time in the future, when they should automatically appear.
Perhaps you have offers or coupons that need to expire after a certain date, or maybe some task has a deadline by which it must be completed.
This gem will neaten up your model code whenever your model instances need to be divided into to groups: those of them whos date field is before `Time.now`, and those whos date field is after `Time.now`

##Functionality

###Dynamic Scopes

Assuming that the model has a datetime field called `published_at`, one can simply call the {DateScopes::ClassMethods#has_date_scopes has_date_scopes} method in the model defintion like so:

    class Post < ActiveRecord::Base
      has_date_scopes
    end
    
This will create the following scopes on the post class

    published
    
    unpublished
    nonpublished
    non_published
    not_published
    
The first scope will return all `Post` records whose `published_at` field is in the past.
All the other scopes will return the `Post` records whose `published_at` field is in the future.
The duplication of the negative scopes is just in the interests of natural looking code.
Note that any records whose `published_at` field exactly equals `Time.now` will fall into both scopes.
Any record with a `nil` `published_at` field will be in the negative scopes, `unpublished` and so on.

###Virtual Accessors

Use of the macro also creates an automatic virtual getter/setter pair, allowing you to interact with the `published_at` column as if it were a boolean column called `published` in that it defines the following methods:

    published
    published?
    
    published=
    
The first two simply return true or false depending on whether the field is in the past or future, much the same as the scopes described above. The second is more interesting, in that it accepts a boolean.
If it is passed `true`, it will set the `published_at` column to `Time.now`. If it is passed `false` it sets `published_at` to `nil`. Again it is obvious how this complements the scopes.

These virtual boolean setters/getters function exactly like real ones, so feel free to use them in your forms and such, in exactly the same way as you would as if you had a real boolean column in your schema.
This can be used to keep a record of when a user set a boolean as true, for example if your date column is `deleted_at` you could use the `deleted=` virtual setter in a form so the user can 'delete' the record easily, and you will have a record in the `deleted_at` column of when this change took place.
Obviously one could then use the `non_deleted` scope to hide those records from the index action etc.

##Customization

The only option accepted by {DateScopes::ClassMethods#has_date_scopes has_date_scopes} currently is `column` which simply changes the field name used and the corresponding dynamic scopes/setters/getters from its default of `:published`.
For example if one had a model `Order` with a `DateTime` column called `filled_at` one could define it like this:

    class Order < ActiveRecord::Base
      has_date_scopes :column => :filled
    end
    
Then the `Order` class would have the following scopes:

    filled
    
    unfilled
    nonfilled
    non_published
    not_published
    
**NOTE**: The column option actually takes the verb that will form part of the various dynamic methods, and then adds `_at` to that name to find the name of the database column. In future it should be made to accept either but the current interface will not be broken. If the correct database column for the `:column` option is not found, the macro method will raise an exception.
