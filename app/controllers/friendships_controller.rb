class FriendshipsController < ApplicationController
  before_action :require_sign_in

  def create
    @friendship = current_user.friendships.build(friendship_params.merge!(friend_id: params[:friend_id]))
    friend = User.find(params[:friend_id])
    if !current_user.follows_or_same?(friend) && @friendship.save 
      redirect_to people_path
    else
      flash[:alert] = "Something went wrong and could not follow user"
      redirect_to user_path(params[:friend_id])
    end
  end

  def destroy
    @friend = Friendship.find(params[:id])
    if @friend.destroy
      flash[:notice] = "#{@friend.friend.full_name} unfollowed."
    else
      flash[:alert] = "#{@friend.friend.full_name} could not be unfollowed."
    end
    redirect_to people_path 
  end

private
  def friendship_params
    params.fetch(:friendship, {}).permit(:friend_id, :user_id)
  end
end
