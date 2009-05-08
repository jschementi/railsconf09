class Picture < ActiveRecord::Base
  has_many :comments
  belongs_to :album
  belongs_to :person
  has_many :taggings, :as => :taggable
  has_many :tags, :through => :taggings

  IMG_PATH = RAILS_ROOT + '/db/images/'

  def self.find_for(person, options)
    find_all_by_person_id(person.id, options)
  end
  
  #FIXME: still SQL
  def self.search(term, options={})
    options = {:limit => 20, :order => "created_at DESC"}.merge(options)
    unless term.blank?
      options.merge!(:conditions => ['title LIKE ?', "%#{term}%"])      
    end
    all(options)
  end

  def self.tagged_with(tag_name)
    Picture.all(:include => [:taggings => :tag], :conditions => {:tags => {:name => tag_name}})
  end
 
  def data
    begin
      input = FileStream.new((IMG_PATH + self['data']), FileMode.open)
      reader = BinaryReader.new input
      input_bytes = reader.ReadBytes(input.length)
      reader.close
      input.close
      input_bytes
    rescue
      File.open(IMG_PATH + self['data'], 'rb'){ |f| f.read }
    end
  end

  def data=(data)
    if data.respond_to?(:read)
      self.filename = data.original_filename
      data = data.read
    end
    t = Time.now
    data_id = Digest::SHA1.hexdigest(t.to_s + '-' + t.usec.to_s) + '.jpg'
    require 'fileutils'
    FileUtils.mkdir IMG_PATH unless File.exist? IMG_PATH
    File.open(IMG_PATH + data_id, 'wb') {|f| f.write data }
    self['data'] = data_id
  end

  def thumbnail_data
    data
  end

  def thumbnail_data=(data)
    data=(data)
  end

  def to_xml
    super(:except => :data)
  end  
end
