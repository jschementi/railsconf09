require 'person'

puts "Loading .NET Libraries #{Time.now}"
require 'mscorlib'
require 'system'
require 'System.Drawing'
require 'System.Windows.Forms'

include System
include System::Drawing
include System::Windows::Forms
include System::ComponentModel

puts "Starting app #{Time.now}"

require 'c:/dev/repl'

class MyForm < Form # System::Windows::Forms
  def initialize
    @binding_src = BindingSource.new
    @datagrid = DataGridView.new
    self.controls.add @datagrid
    @datagrid.dock = DockStyle.top;
    self.size = Size.new 800, 200
    self.load do |s,e|
      @customer_list = BindingList.of(Person).new

      # Make sure all fields are loaded by calling
      # one field on each record
      Person.all.each{|pe| pe.age }

      Person.all.each do |pe|
        @customer_list.add pe
      end rescue nil # Note sure why rescue is needed

      @binding_src.data_source = @customer_list
      @datagrid.data_source = @binding_src
    end
  end
end

t = Thread.new do
  Application.enable_visual_styles
  Application.run MyForm.new
end

repl binding
