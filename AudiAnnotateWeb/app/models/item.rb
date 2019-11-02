class Item
  include ActiveModel::Model
  attr_accessor :label, :user_name, :repo_name, :audio_url

  def initialize(user_name, repo_name, label=nil, audio_url=nil)
    @project = Project.new(user_name, repo_name)
    @label=label
    @audio_url=audio_url
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
    File.join(@project.repo_path, label)
  end

  def manifest_path
    File.join(item_path, 'manifest.json')
  end

  def manifest_contents
    {
      label: label,
      items: [
        {
          canvas: audio_url
        }
      ]
    }.to_json
  end

end