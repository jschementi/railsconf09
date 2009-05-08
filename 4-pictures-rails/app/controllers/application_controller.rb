# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '9c90ee1ab8238b2ca72a5b0e2374e345'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  helper_method :current_person
  before_filter :set_tags!
  
  private
    def current_person
      @current_person ||= logged_in? ? Person.find(session[:person_id]) : nil
    end
    
    def logged_in?
      !session[:person_id].blank?
    end
    
    def authenticate
      if !logged_in?
        flash[:notice] = "Please log in to continue!"
        redirect_to new_session_url
      end
    end
    
    def set_tags!
      @tags = Tag.all
    end
end
