class ProjectController < ApplicationController
  before_action :connect

  def all
    client = @github_client || Octokit.client
    @repos = client.search_repositories("topic:audiannotate fork:true", sort: 'stars', per_page: 20).items
  end

  def mine
    user_name = @github_client.user.login
    if @github_client.repositories.size == 0
      @repos = []
    else
      @repos = @github_client.search_repositories("user:#{user_name} topic:audiannotate fork:true", sort: 'stars').items
    end
    @shared_repos = @github_client.repositories(nil, {:type => 'member'}) # shared repos are not filterd by topic
  end


  def new
    # display the form
    @project = Project.new(@github_client.user.login, nil)
  end

  def create
    # instantiate the object from form parameters
    @project = Project.new(project_params[:user_name], project_params[:repo_name], project_params[:description], project_params[:label])
    if @project.valid?
      # create the repo 
      @project.create(@github_client)

      redirect_to project_path(@project.user_name, @project.repo_name)
    else
      render :new
    end
  end

  def show
    @project = Project.new(params[:user_name], params[:repo_name])
    @project.clone(session[:github_token])
    begin
      @pages_site_status = @github_client.pages("#{params[:user_name]}/#{params[:repo_name]}").status || "Missing"
    rescue 
      @pages_site_status = "Missing"
    end
    @repo = @github_client.repository("#{@project.user_name}/#{@project.repo_name}")
    @folders = Dir.glob(File.join(@project.repo_path,'_data','*')).select {|f| File.directory? f}
    @item_count = Dir.glob(File.join(@project.repo_path,'_manifests','*')).reject {|fn| fn.match?('anne-sexton--woodberry--1974.md')}.count
  end


  def build_status
    begin
      pages_site_status = @github_client.pages("#{params[:user_name]}/#{params[:repo_name]}").status
    rescue Octokit::NotFound
      pages_site_status = "Missing"
    end
    render json: pages_site_status
  end

  def toggle_layout
    aviary=params[:aviary]
    @project = Project.new(params[:user_name], params[:repo_name])
    @project.toggle_layout(session[:github_token], aviary)
    redirect_to project_path(@project.user_name, @project.repo_name)
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:user_name, :repo_name, :description, :label)
    end


end
