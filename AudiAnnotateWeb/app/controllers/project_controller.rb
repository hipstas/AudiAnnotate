class ProjectController < ApplicationController
  before_action :connect, except: :all

  def all
    @repos = Octokit.client.search_repositories("topic:audiannotate", sort: 'stars').items
  end

  def mine
    # TODO  replace hard-wired string with current user
    user_name = @github_client.user.login
    @repos = @github_client.search_repositories("user:#{user_name} topic:audiannotate", sort: 'stars').items
  end


  def new
    # display the form
    @project = Project.new
  end

  def create
    # instantiate the object from form parameters
    @project = Project.new(project_params)
    # create the repo 
    @github_client.create_repository(@project.name, {topics: ['audiannotate']})

    # redirect or show an error
    redirect_to project_path(@github_client.user.login, @project.name)
  end

  def show
    user_name = params[:user_name]
    repo_name = params[:repo_name]
    @repo = Octokit.repository("#{user_name}/#{repo_name}")
  end


  private

    def connect
      @github_client = Octokit::Client.new(access_token: session[:github_token])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name)
    end


end
