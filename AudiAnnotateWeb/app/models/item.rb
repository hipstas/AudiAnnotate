class Item
  include ActiveModel::Model
  attr_accessor :label, :slug, :user_name, :repo_name, :audio_url, :duration, :provider_uri, :provider_label, :homepage

  def initialize(user_name, repo_name, label=nil, audio_url=nil, duration=nil, provider_uri=nil, provider_label=nil, homepage=nil)
    @project = Project.new(user_name, repo_name)
    @label=label
    @audio_url=audio_url
    @duration=duration
    @provider_label=provider_label
    @provider_uri=provider_uri
    @homepage=homepage
  end    

  def self.from_file(user_name, repo_name, slug)
    item = Item.new(user_name, repo_name)
    item.slug=slug
    manifest = JSON.parse(File.read(item.manifest_path))

    item.label = manifest['label']['en'][0]
    item.homepage = manifest['homepage'][0]['label']['en'][0] if manifest['homepage']
    if manifest['provider']
      item.provider_uri = manifest['provider'][0]['id']
      item.provider_label = manifest['provider'][0]['label']['en'][0]
    end
    if manifest['items']
      item.duration = manifest['items'][0]['duration']
      item.audio_url = manifest['items'][0]['items'][0]['items'][0]['body']['id']
    end

    item
  end

  def write_file(path, contents)
    FileUtils.mkdir_p(File.dirname(path))
    File.write(path,contents)
  end

  def save(access_token)
    # sync with github
    git = Git.open(@project.repo_path)  # TODO consider using the logger here
    git.branch('gh-pages').checkout
    git.pull("https://#{access_token}@github.com/#{user_name}/#{repo_name}.git", 'gh-pages')

    new_item=false
    # create the directory and manifest file
    unless Dir.exists?(item_path)
      new_item=true
      Dir.mkdir(item_path)
    end
    write_file(manifest_path, manifest_contents)
    write_file(jekyll_collection_item_path, jekyll_collection_item_contents)
    write_file(jekyll_collection_item_manifest_path, jekyll_collection_item_manifest_contents)

    # canvases.each { |canvas| canvas.save }

    # add, commit, and push
    git.add(item_path)
    git.add(manifest_path)
    git.add(jekyll_collection_item_path)
    git.add(jekyll_collection_item_manifest_path)
    if new_item
      git.commit("Added #{label}")
    else
      git.commit("Updated #{label}")
    end      
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
    File.join(@project.repo_path, '_data', slug)
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

  def jekyll_collection_item_manifest_path
    File.join(@project.repo_path, '_manifests', "#{slug}.md")
  end

  def jekyll_collection_item_manifest_contents
    ApplicationController::render template: 'items/jekyll_collection_manifest.md', layout: false, locals: {item: self}
  end

  def slug=(slug)
    @slug=slug
  end

  def slug
    @slug || label.gsub(/\W+/, '-').downcase
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