class PicturesController < ApplicationController
  
  before_filter :authenticate, :only => [:new, :create]
  
  def index
    filtered_pictures(:limit => 13)
    filtered_albums(:limit => 7)
    respond_to do |format|
      format.html
      format.js { render :json => @pictures }
      format.xml { render :xml => @pictures }
    end
  end
  
  def mine
    params[:person_id] = current_person.id
    @pictures = filtered_pictures(:limit => 13)
    @albums   = filtered_albums(:limit => 7)
    respond_to do |format|
      format.html { render :action => 'index' }
      format.js { render :json => @pictures }
      format.xml { render :xml => @pictures }
    end
  end
  
  def new
    @picture = Picture.new(:album_id => params[:album_id])
  end
  
  def create
    @picture = current_person.pictures.build(params[:picture])
    if @picture.save
      flash[:notice] = "Thanks, we've got it!"
      redirect_to @picture
    else
      
    end
  end
  
  def show
    @picture = Picture.find(params[:id])
    respond_to do |format|
      format.html
      format.js { render :json => @picture }
      format.xml { render :xml => @picture }
    end
  end
  
  def serve
    @picture = Picture.find(params[:id])
    send_data @picture.data, :filename => @picture.filename, :mime_type => @picture.mime_type
  end
  
  def serve_thumbnail
    @picture = Picture.find(params[:id])
    send_data(@picture.thumbnail_data || @picture.data, :filename => @picture.filename, :mime_type => @picture.mime_type)
  end

  def tagged
    @pictures = Picture.tagged_with(params[:tag])
  end
  
  private
  
  def filtered_pictures(options)
    if person
      @pictures = Picture.find_for(person, options)
    else
      @pictures = Picture.search(params[:term], options)
    end   
  end

  def filtered_albums(options)
    if person
      @albums = Album.find_for(person, options)
    else
      @albums = Album.search(params[:term], options)
    end   
  end
  
  def person
    @person ||= Person.find(params[:person_id]) if params[:person_id]
  end

end
