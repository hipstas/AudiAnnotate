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


  def new
    # display the form
    @project = Project.new
  end

  def create
    # instantiate the object from form parameters
    @project = Project.new(project_params)
    # create the repo 

    # redirect or show an error
    redirect_to project_path('benwbrum', @project.name)
  end

  def show
    user_name = params[:user_name]
    repo_name = params[:repo_name]
    @repo = Octokit.repository("#{user_name}/#{repo_name}")
  end


  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name)
    end


end
