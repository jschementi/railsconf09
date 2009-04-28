require 'mscorlib'
require 'system'
require 'System.Data'
require 'System.Xml, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'
require 'System.Deployment, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
require 'System.DirectoryServices, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'

include System
include System::DirectoryServices
include System::IO
include System::Collections

ROOT = "IIS://localhost/W3SVC/1/root"

# Is IIS installed?
raise "Please make sure IIS is installed on this machine." unless DirectoryEntry.exists ROOT

class IISSetup
  class << self
    def do(app_name, app_path)
      Directory.create_directory app_path unless Directory.exists app_path
      root = DirectoryEntry.new ROOT
      create_app get_direct_parent_app(root, app_name), 
                 app_name.substring(app_name.last_index_of('/') + 1),
                 app_path
    end

    def get_direct_parent_app current_entry, current_vpath
      while current_vpath.starts_with '/'
        current_vpath = current_vpath.substring 1
      end

      i = current_vpath.index_of '/'

      return current_entry if i < 0

      cur_name = current_vpath.substring 0, i
      cur_vpath = current_vpath.substring i + 1

      cur_entry = get_app(cur_name, current_entry) || raise(Exception.new("Please make sure parent application #{cur_name} exist under #{current_entry.parent.name}"))

      get_direct_parent_app cur_entry, cur_vpath
    end

    def create_app entry_parent, app_name, app_path
      new_app = get_app app_name, entry_parent
      unless new_app
        new_app = entry_parent.children.add app_name, "IIsWebVirtualDir"
        new_app.invoke "AppCreate", true
        new_app.commit_changes
        puts "#{app_name} has been created successfully."
      else
        puts "Found #{app_name}"
      end

      #new_app.properties.each do |i|
      #  puts "#{i.PropertyName} => , #{i.Value}
      #end
      new_app.properties["DirBrowseFlags"].value = -2147483586 # enable directory browsing
      new_app.properties["Path"].value = app_path
      new_app.properties["AccessRead"][0] = true
      new_app.properties["AccessExecute"][0] = false
      new_app.properties["AccessWrite"][0] = false
      new_app.properties["ContentIndexed"][0] = true
      new_app.properties["AppFriendlyName"][0] = app_name
      new_app.properties["AccessScript"][0] = true
      new_app.commit_changes

      puts "#{app_name} has been configured successfully."
    end

    def get_app name, entryparent
      entryparent.children.select{|entry| entry.name.to_lower == name.to_lower}.first
    end

    def delete virdir, entry_parent    
      entry_parent.invoke "Delete", ["IIsWebVirtualDir", virdir]
      entry_parent.commit_changes
    end
  end
end

if __FILE__ == $0
  def run
    app_name = ARGV[0].to_clr_string rescue(raise(Exception.new("Application name required as first command-line arg")))
    app_path = ARGV[1].to_clr_string rescue(raise(Exception.new("Application path required as second command-line arg")))
    IISSetup.do(app_name, app_path)
  rescue => e
    puts <<-EOS
  Failed with exception: #{e}
  Please make sure following:
      1. IIS is installed
      2. On Vista, IIS6 Management Compatibility component is installed.
      3. On Vista, this tool run as Administrator
  EOS
    exit -1
  end
  
  run
end

