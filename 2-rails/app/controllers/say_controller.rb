class SayController < ApplicationController
  def index
    @msg1 = "Hello"
    @msg2 = "World"
    render :inline => 'IronRuby running Rails says "<%= @msg1 %>, <b><%= @msg2 %></b>" at <%= Time.now %>'
  end
end
