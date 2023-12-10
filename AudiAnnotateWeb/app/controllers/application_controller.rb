class ApplicationController < ActionController::Base

private
  def connect
    # write github token to a file
    File.write(File.join(Rails.root, 'tmp', 'github_token'), session[:github_token])
    @github_client = Octokit::Client.new(access_token: session[:github_token])
  end
end
