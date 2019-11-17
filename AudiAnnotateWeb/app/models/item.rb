class Item
  include ActiveModel::Model
  attr_accessor :label, :user_name, :repo_name, :audio_url, :duration

  def initialize(user_name, repo_name, label=nil, audio_url=nil, duration=nil)
    @project = Project.new(user_name, repo_name)
    @label=label
    @audio_url=audio_url
    @duration=duration
  end    

  def save(access_token)
    # sync with github
    git = Git.open(@project.repo_path)  # TODO consider using the logger here
    git.branch('gh-pages').checkout
    git.pull("https://#{access_token}@github.com/#{user_name}/#{repo_name}.git", 'gh-pages')

    # create the directory and manifest file
    unless Dir.exists?(item_path)
      Dir.mkdir(item_path)
    end
    File.write(manifest_path, manifest_contents)
    File.write(jekyll_collection_item_path, jekyll_collection_item_contents)

    # canvases.each { |canvas| canvas.save }

    # add, commit, and push
    git.add(item_path)
    git.commit("Added #{label}")
    response = git.push("https://#{access_token}@github.com/#{user_name}/#{repo_name}.git", 'gh-pages')    
    true
  end


  def user_name
    @project.user_name
  end

  def user_name=(user_name)
    @project.user_name = user_name
  end


  def repo_name
    @project.repo_name
  end

  def repo_name=(repo_name)
    @project.repo_name = repo_name
  end

  def item_path
    File.join(@project.repo_path, '_data', label)
  end

  def manifest_path
    File.join(item_path, 'manifest.json')
  end

  def manifest_contents
    ApplicationController::render template: 'items/manifest.json', layout: false, locals: {item: self}
  end

  def jekyll_collection_item_path
    File.join(@project.repo_path, '_items', "#{slug}.md")
  end

  def jekyll_collection_item_contents
    ApplicationController::render template: 'items/jekyll_collection_item.md', layout: false, locals: {item: self}
  end


  def slug
    label
  end

  #######################
  # Manifest helpers
  #######################

  def uri_root
    "#{@project.uri_root}/#{slug}"
  end

  def manifest_uri
    "#{uri_root}/manifest.json"
  end

  def manifest_label
    label
  end

  def canvases
    [Canvas.new(self, audio_url, 1, duration)]
  end

end