class Tag < ActiveRecord::Base
  def self.all(*args)
    find(:all, *args)
  end
end
