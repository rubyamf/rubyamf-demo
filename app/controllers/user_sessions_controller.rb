class UserSessionsController < ApplicationController

  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  def show

    # Check if already logged in when browser refreshes. If you refresh the browser, Authlogic remembers the
    # session. This picks up the session and logs in the application. Otherwise, trying to login fails.
    respond_to do |format|
        notice = 'Logged in!'  if current_user_session
        format.amf  { render :amf => CallResult.new(current_user_session, notice) }
        format.html { redirect_to(current_user_session, :notice => notice) }
        format.xml  { render :xml =>  current_user_session }
    end
  end
  
  def new
    @user_session = UserSession.new
  end

  def create
    # AMF remote credentials are set in the Flex application in the
    # com.rubyamf.demo.managers.UserSessionsManager class.
    @user_session = UserSession.new(credentials)

    respond_to do |format|
      if @user_session.save
        notice = 'Login successful!'
        format.amf  { render :amf => CallResult.new(@user_session, notice) }
        format.html { redirect_to(@user_session, :notice => notice) }
        format.xml  { render :xml =>  @user_session, :status => :created, :location => @user_session }
      else
        format.amf  { render :amf => FaultObject.new( @user_session.errors.full_messages.join(".\n") ) }
        format.html { render :action => "new" }
        format.xml  { render :xml => @user_session.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    current_user_session.destroy

    respond_to do |format|
      format.amf  { render :amf => CallResult.new(true,  'Logout successful!') }
      format.html { redirect_back_or_default new_user_session_url new_user_session_url, :notice => 'Logout successful!' }
      format.xml  { head :ok }
    end
  end
end
