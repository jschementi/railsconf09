# CLR event-like functionality for Ruby. 
# 
# >>> foo_event, on_foo_event = RubyEvent.build
# >>> handler = foo.add { puts "foo event fired" }
# >>> # or 
# >>> def another
# >>>   puts "foo event fired again"
# >>> end
# >>> foo.add method(:another)
# >>> on_foo_event.call
# foo event fired
# foo event fired again
# => nil
class RubyEvent

  # List of event handlers of type Proc
  attr_reader :handlers

  # Triggers the event; Proc which calls all handlers
  attr_reader :caller
  
  def initialize
    @handlers = []
    @caller ||= lambda do |*args|
      @handlers.each { |h| h.call(*args) }
      nil
    end
  end

  def add(event = nil, &block)
    event = block if event.nil? && block_given?
    if event.kind_of?(RubyEvent)
      @handlers.concat event.handlers
    else
      raise TypeError, "event handler must respond to call" unless event.respond_to?(:call)
      @handlers << event
    end
    event
  end
end
