class Project
  include ActiveModel::Model
  attr_accessor :user_name, :repo_name

  validates :repo_name, format: { with: /\A[\-\w]+\Z/, message: 'only allows letters, numbers, dashes, and underscores'}


  def initialize(user_name, repo_name)
    @user_name = user_name
    @repo_name = repo_name
  end


  def create(github_client)
    response = github_client.create_repository(@repo_name, {topics: ['audiannotate']})
    github_client.replace_all_topics(response.full_name, ['audiannotate'])

    github_client.create_contents(
      response.full_name, #repository full name
      'README.md', 
      'Initial creation', 
      'Repository created by AudiAnnotateWeb, version 0.0.0', # file contents
      {branch: 'gh-pages'})
  end

  def clone(access_token)
    # due to security concerns, we shouldn't actually clone the repository but pull into an empty one
    # see https://github.blog/2012-09-21-easier-builds-and-deployments-using-git-over-https-and-oauth/
    # create a (temporary-ish) directory for the user if there isn't one
    Dir.mkdir(user_path) unless Dir.exists?(user_path)

    # create a (temporary-ish) directory for the repo if there isn't one and initialize it
    unless Dir.exists?(repo_path)
      Dir.mkdir(repo_path)
      Git.init(repo_path)
    end

    # pull into the repo, using the access token
    git = Git.open(repo_path)  # TODO consider using the logger here
    # remote = git.add_remote('origin', "https://#{access_token}@github.com/#{user_name}/#{repo_name}.git")
    git.pull("https://#{access_token}@github.com/#{user_name}/#{repo_name}.git", 'gh-pages')
  end

  def user_path
    File.join(Rails.root, 'tmp', user_name) 
  end

  def repo_path
    File.join(user_path, repo_name)
  end

  def uri_root
    "https://#{user_name}.gihub.io/#{repo_name}"
  end


end