class CommentsController < ApplicationController

  before_filter :check_for_live_demo, :only => [:create, :update, :destroy]
  before_filter :require_user, :only => [:new, :create, :edit, :update, :destroy]
  before_filter :get_post, :only => [:create, :edit, :update, :index]

  # GET /comments
  # GET /comments.xml
  def index
    @comments = @post.comments

    respond_to do |format|
      format.amf  { render :amf => @comments }
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.xml
  def show
    @comment = @post.comments.find(params[:id])

    respond_to do |format|
      format.amf  {render :amf => @comment}
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.xml
  def new
    @comment = Comment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
  end

  # POST /comments
  # POST /comments.xml
  def create
    if is_amf?
      @comment = @post.comments.push(params[:comment])
    else
      @comment = @post.comments.build(params[:comment])
    end

    respond_to do |format|
      if @post.save
        notice = "Comment was successfully #{request.action}d."
        format.amf  {render :amf => CallResult.new(@comment, notice) }
        format.html { redirect_to(@comment, :notice => notice) }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        format.amf  {render :amf => FaultObject.new( "Comment was not #{request.action}d.\n" + @comments.full_messages.join(".\n") ) }
        format.html { render :action => "new" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    if is_amf?
      # Update and create work the same for amf without scaffolding, which is not used in this example
      create
    else
       @comment = @post.comments.find(params[:id])
    end
    
    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to(@comment, :notice => 'Comment was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.amf  { render :amf => CallResult.new(true, 'Comment Deleted!') }
      format.html { redirect_to(comments_url) }
      format.xml  { head :ok }
    end
  end

private
  def get_post
    blog = Blog.find(params[:blog_id])
    @post = blog.posts.find(params[:post_id])
  end
end
