class ApplicationController < ActionController::Base

private
  def connect
    @github_client = Octokit::Client.new(access_token: session[:github_token])
  end
end
