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
    @project = Project.new(@github_client.user.login, nil)
  end

  def create
    # instantiate the object from form parameters
    @project = Project.new(project_params[:user_name], project_params[:repo_name])
    # create the repo 
    response = @github_client.create_repository(@project.repo_name, {topics: ['audiannotate']})
    @github_client.replace_all_topics(response.full_name, ['audiannotate'])

    @github_client.create_contents(
      response.full_name, #repository full name
      'README.md', 
      'Initial creation', 
      'Repository created by AudiAnnotateWeb, version 0.0.0', # file contents
      {branch: 'gh-pages'})
    # redirect or show an error
    redirect_to project_path(@project.user_name, @project.repo_name)
  end

  def show
    @project = Project.new(params[:user_name], params[:repo_name])
    @project.clone(session[:github_token])
    @repo = Octokit.repository("#{@project.user_name}/#{@project.repo_name}")
    @folders = Dir.glob(File.join(@project.repo_path,'*')).select {|f| File.directory? f}
  end


  private
    def connect
      @github_client = Octokit::Client.new(access_token: session[:github_token])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:user_name, :repo_name)
    end


end
