class RelationshipsController < ApplicationController
  before_filter :authenticate

  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
  #  flash.now[:notice]= "You followed " + @user.name + "!"
    respond_to do |format|
    	format.html {redirect_to @user }
    	format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
  #  flash.now[:notice] = "You unfollowed " + @user.name + "!"
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end