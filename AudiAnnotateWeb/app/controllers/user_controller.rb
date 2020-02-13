class UserController < ApplicationController
  def login
    session[:github_token] = request.env['omniauth.auth'].credentials.token
    redirect_to my_projects_path
  end

  def logout
    session[:github_token] = nil
    redirect_to all_projects_path
  end    
end
