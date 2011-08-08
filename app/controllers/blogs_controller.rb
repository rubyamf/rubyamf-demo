class BlogsController < ApplicationController

  before_filter :check_for_live_demo, :only => [:create, :update, :destroy]
  before_filter :require_user, :only => [:new, :edit, :create, :update, :destroy]

  # GET /blogs
  # GET /blogs.xml
  def index
    @blogs = Blog.order('created_at').all

    respond_to do |format|
      format.amf { render :amf => CallResult.new(@blogs) }
      format.html # index.html.erb
      format.xml  { render :xml => @blogs }
    end
  end

  # GET /blogs/1
  # GET /blogs/1.xml
  def show
    @blog = Blog.find(params[:id])

    respond_to do |format|
      format.amf { render :amf => CallResult.new(@blog), :mapping_scope => :show }
      format.html # show.html.erb
      format.xml  { render :xml => @blog }
    end
  end

  # GET /blogs/new
  # GET /blogs/new.xml
  def new
    @blog = Blog.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @blog }
    end
  end

  # GET /blogs/1/edit
  def edit
    @blog = Blog.find(params[:id])
  end

  # POST /blogs
  # POST /blogs.xml
  def create
     if is_amf?
      @blog = params[:blog]
      current_user.blogs << params[:blog]
    else
      @blog = current_user.blogs.build(params[:blog])
    end

    respond_to do |format|
      if current_user.save
        notice = "Blog was successfully #{action_name}d."
        format.amf  {render :amf => CallResult.new(@blog, notice), :mapping_scope => :show }
        format.html { redirect_to(@blog, :notice => notice) }
        format.xml  { render :xml => @blog, :status => :created, :location => @blog }
      else
        format.amf  {render :amf => FaultObject.new( "Blog was not #{action_name}d.\n" + @blog.full_messages.join(".\n") ) }
        format.html { render :action => "new" }
        format.xml  { render :xml => @blog.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /blogs/1
  # PUT /blogs/1.xml
  def update
    if is_amf?
      # Update and create work the same for amf without scaffolding, which is not used in this example
      create
    else
        @blog = Blog.find(params[:id])
    end

    respond_to do |format|
      if @blog.update_attributes(params[:blog])
        format.html { redirect_to(@blog, :notice => 'Blog was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @blog.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /blogs/1
  # DELETE /blogs/1.xml
  def destroy
    @blog = Blog.find(params[:id])
    @blog.destroy

    respond_to do |format|
      format.amf  { render :amf => CallResult.new(true,  'Blog deleted!') }
      format.html { redirect_to(blogs_url) }
      format.xml  { head :ok }
    end
  end
end
