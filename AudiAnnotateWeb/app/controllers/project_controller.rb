class ProjectController < ApplicationController
  def all

  	# TODO change this to use the search API for all public AA repos
  	@repos = Octokit.repositories('saracarl')

  end

  def mine
    # TODO  replace hard-wired string with current user
    @repos = Octokit.repositories('saracarl')
  end

  def show
    user_name = params[:user_name]
    repo_name = params[:repo_name]
    @repo = Octokit.repository("#{user_name}/#{repo_name}")
  end
end
