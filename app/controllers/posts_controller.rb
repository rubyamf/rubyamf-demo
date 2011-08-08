class PostsController < ApplicationController

  before_filter :check_for_live_demo, :only => [:create, :update, :destroy]
  before_filter :require_user, :only => [:new, :create, :edit, :update, :destroy]
  before_filter :get_blog, :only => [:create, :update, :index, :show]
  
  # GET /posts
  # GET /posts.xml
  def index
    @posts = @blog.posts

    respond_to do |format|
      format.amf  { render :amf =>CallResult.new(@posts) }
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    @post = @blog.posts.find(params[:id])

    respond_to do |format|
      format.amf  { render :amf => CallResult.new(@post), :mapping_scope => :show_comments}
      format.html # show.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.xml
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.xml
  def create
    if is_amf?
      @post = params[:post]
      @blog.posts << params[:post]
    else
      @post = @blog.posts.build(params[:post])
    end

    respond_to do |format|
      notice =  "Post was successfully #{action_name}d."
      if @blog.save
        format.amf  { render :amf => CallResult.new(@post, notice) }
        format.html { redirect_to(@post, :notice => notice) }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.amf  {render :amf => FaultObject.new( "Post was not #{action_name}d.\n" + @post.full_messages.join(".\n") ) }
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    if is_amf?
      # Update and create work the same for amf without scaffolding, which is not used in this example
      create
    else
       @post = Post.find(params[:id])
    end

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to(@post, :notice => 'Post was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.amf  { render :amf => CallResult.new(true, "Post Deleted!") }
      format.html { redirect_to(posts_url) }
      format.xml  { head :ok }
    end
  end


  def get_blog
    @blog = Blog.find(params[:blog_id])
  end
end
