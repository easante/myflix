class Admin::BaseController < ApplicationController
  before_action :require_sign_in
  before_action :require_admin

  def index
  end

end
