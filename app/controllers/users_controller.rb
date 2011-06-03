class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => :destroy

  def new
  	@user = User.new
  	@title = "Sign up"
  end

  def index
    #@users = User.all
    @users = User.paginate(:page => params[:page])
    @title = "All users"
  end

  def show
  	@user = User.find(params[:id])
  	@title = @user.name
  end

  def create
  	@user = User.new(params[:user])
  	if @user.save
      sign_in @user
  		flash[:success] = "Welcome!"
  		redirect_to @user #can also use redirect_to user_path i believe
  	else
  		@title = "Sign up"
  		@user.password = ""
  		@user.password_confirmation = ""
  		render 'new'
  	end
  end

  def edit
    # @user = User.find(params[:id]) #correct_user in the before_filter defines @user, so we can omit
    @title = "Edit user"
  end

  def update
    #@user = User.find(params[:id]) #correct_user in the before_filter defines @user, so we can omit
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated!"
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end
  
  private

    def authenticate
      deny_access unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
#      session[:return_to] = request.fullpath
      #redirect_to(root_path) unless current_user?(@user)
      if !current_user?(@user)
        flash[:notice] = "You can't change somebody else's settings!"
        redirect_to(root_path) #redirect_to(:back)
      end
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
