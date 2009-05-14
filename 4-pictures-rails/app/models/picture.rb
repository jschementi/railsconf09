class Picture < ActiveRecord::Base
  has_many :comments
  belongs_to :album
  belongs_to :person
  has_many :taggings, :as => :taggable
  has_many :tags, :through => :taggings

  before_destroy :remove_images

  IMG_PATH = RAILS_ROOT + '/db/images/'

  def self.find_for(person, options)
    options = {:limit => 20, :order => "id DESC"}.merge(options)
    find_all_by_person_id(person.id, options)
  end

  def self.search(term, options={})
    options = {:limit => 20, :order => "id DESC"}.merge(options)
    unless term.blank?
      options.merge!(:conditions => ['title LIKE ?', "%#{term}%"])      
    end
    all(options)
  end

  def self.tagged_with(tag_name)
    Picture.all(:include => [:taggings => :tag], :conditions => {:tags => {:name => tag_name}})
  end

  def remove_images
    FileUtils.rm _filename if File.exist? _filename
    FileUtils.rm _filename(:thumbnail) if File.exist? _filename(:thumbnail)
  end

  def data
    _read_data_from_filename(_filename)
  end

  def data=(new_data)
    _write_data_to_filename(new_data, _filename)
  end

  def thumbnail_data
    _read_data_from_filename(_filename(:thumbnail))
  end

  def thumbnail_data=(new_data)
    _write_data_to_filename(new_data, _filename(:thumbnail))
  end

  def to_xml
    super(:except => [:data, :thumbnail_data])
  end

  private
    require 'fileutils'

    def _read_data_from_filename(filename)
      File.open(filename, 'rb'){ |f| f.read }
    end

    def _write_data_to_filename(data, filename)
      if data.respond_to?(:read)
        self.filename = data.original_filename
        data = data.read
      end

      FileUtils.mkdir IMG_PATH unless File.exist? IMG_PATH

      File.open(filename, 'wb') {|f| f.write data }
    end

    def _generate_filenames
      t = Time.now
      self['data'] ||= Digest::SHA1.hexdigest(t.to_s + '-' + t.usec.to_s)
      self['thumbnail_data'] ||= (self['data'] + '_small')
    end

    def _filename(type = '')
      type = type.to_s + '_' unless type.to_s.empty?
      _generate_filenames
      IMG_PATH + self[type.to_s + 'data'] + '.jpg'
    end
end
