class ProjectController < ApplicationController
  def all

  	# TODO change this to use the search API for all public AA repos
    @repos = Octokit.client.search_repositories("topic:audiannotate", sort: 'stars').items
  	Octokit.repositories('saracarl')

  end

  def mine
    # TODO  replace hard-wired string with current user
    user_name = 'benwbrum'
    @repos = Octokit.client.search_repositories("user:#{user_name} topic:audiannotate", sort: 'stars').items
  end

  def show
    user_name = params[:user_name]
    repo_name = params[:repo_name]
    @repo = Octokit.repository("#{user_name}/#{repo_name}", sort: stars)
  end
end
