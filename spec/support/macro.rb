def set_current_admin
  admin = Fabricate(:user, admin: true)
  session[:user_id] = admin.id
end

def set_current_user
  john = Fabricate(:user)
  session[:user_id] = john.id
end

def current_user
  User.find(session[:user_id])
end

def clear_current_user
  session[:user_id] = nil
end

