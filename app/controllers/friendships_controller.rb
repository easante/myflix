class FriendshipsController < ApplicationController
  before_action :require_sign_in

  def create
    friend = User.find(params[:friend_id])
    Friendship.create(friendship_params.merge!(friend_id: params[:friend_id], 
                      user_id: current_user.id)) unless current_user.follows_or_same?(friend) 
    redirect_to people_path
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
