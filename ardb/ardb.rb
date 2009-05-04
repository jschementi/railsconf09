require 'event' # defines RubyEvent

require 'mscorlib'
require 'system'

include System::ComponentModel

# For use in a ActiveRecord model, to databind it's attributes.
module ActiveRecord::AttributeChangeNotifier
  include INotifyPropertyChanged

  # required by INotifyPropertyChange
  def add_PropertyChanged handler
    @attr_change ||= RubyEvent.new
    repl binding, 'AddPropertyChanged'
    @attr_change.add handler
  end

  # required by INotifyPropertyChange
  def remove_PropertyChanged handler
    @attr_change.remove handler if @attr_change
  end

  # Executed before ActiveRecord::Base#save
  def before_save
    if self.changed?
      @model_changes = self.changes.clone
    end
    true
  end

  # Executed after ActiveRecord::Base#save
  def after_save
    repl binding, 'after_save'
    @model_changes.each do |field, (oldval, newval)|
      @attr_change.caller.call(field, oldval, newval) if @attr_change
    end
    @model_changes = []
  end
end
