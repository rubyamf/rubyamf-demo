class ApplicationController < ActionController::Base
  protect_from_forgery

  helper :all
  helper_method :current_user_session, :current_user, :check_for_live_demo

  # Flag to configure the application for hosting.
  LIVE_DEMO = false

private
  # The hosted live demo version allows user interaction, but does not make any changes to the database.
  def check_for_live_demo
    if LIVE_DEMO && is_amf?
      message = "Live Demo: #{action_name} action cancelled."
      render :amf => CallResult.new(false, message)
      return false
    end
    return true
  end

  # Authlogic methods. See https://github.com/binarylogic/authlogic for more information.
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def require_user
    unless current_user
      flash[:notice] = "You must be logged in to access this content."

      respond_to do |format|
        format.amf  {render :amf => FaultObject.new(flash[:notice])}
        format.html do
          store_location
          redirect_to new_user_session_url
        end
        format.xml  { render :xml => flash[:notice], :status => :unprocessable_entity }
      end
      return false
    end
  end

  def require_no_user
    if current_user
      flash[:notice] = "You must be logged out to access this content."
      respond_to do |format|
        format.amf  {render :amf => FaultObject.new(flash[:notice])}
        format.html do
          store_location
          redirect_to account_url
        end
        format.xml  { render :xml => flash[:notice], :status => :unprocessable_entity }
      end
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
end
