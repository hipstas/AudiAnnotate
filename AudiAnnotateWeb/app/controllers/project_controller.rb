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
    response = @github_client.create_repository(@project.name, {topics: ['audiannotate']})
    @github_client.replace_all_topics(response.full_name, ['audiannotate'])

    @github_client.create_contents(
      response.full_name, #repository full name
      'README.md', 
      'Initial creation', 
      'Repository created by AudiAnnotateWeb, version 0.0.0', # file contents
      {branch: 'gh-pages'})
    # redirect or show an error
    redirect_to project_path(@github_client.user.login, @project.name)
  end

  def show
    user_name = params[:user_name]
    repo_name = params[:repo_name]
    clone(user_name, repo_name, session[:github_token])
    @repo = Octokit.repository("#{user_name}/#{repo_name}")
  end


  private

    def connect
      @github_client = Octokit::Client.new(access_token: session[:github_token])
    end

    def clone(user_name, repo_name, access_token)
      # due to security concerns, we shouldn't actually clone the repository but pull into an empty one
      # see https://github.blog/2012-09-21-easier-builds-and-deployments-using-git-over-https-and-oauth/
      # create a (temporary-ish) directory for the user if there isn't one
      user_path = File.join(Rails.root, 'tmp', user_name) 
      Dir.mkdir(user_path) unless Dir.exists?(user_path)

      # create a (temporary-ish) directory for the repo if there isn't one and initialize it
      repo_path = File.join(user_path, repo_name)
      unless Dir.exists?(repo_path)
        Dir.mkdir(repo_path)
        Git.init(repo_path)
      end

      # pull into the repo, using the access token
      git = Git.open(repo_path)  # TODO consider using the logger here
      # remote = git.add_remote('origin', "https://#{access_token}@github.com/#{user_name}/#{repo_name}.git")
      git.pull("https://#{access_token}@github.com/#{user_name}/#{repo_name}.git", 'gh-pages')
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name)
    end


end
