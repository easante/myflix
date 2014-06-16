class PeopleController < ApplicationController
  before_action :require_sign_in

  def index
    @friendships = current_user.friendships
  end
end
