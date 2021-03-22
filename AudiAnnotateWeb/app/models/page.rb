class Page
  require 'open-uri'
  include ActiveModel::Model
  attr_accessor :title, :slug, :user_name, :repo_name

  def initialize(user_name, repo_name, title=nil)
    @project = Project.new(user_name, repo_name)
    @title=title
  end    

  def write_file(path, contents)
    FileUtils.mkdir_p(File.dirname(path))
    File.write(path,contents)
  end


  def self.from_file(user_name, repo_name, slug)
    page = Page.new(user_name, repo_name)
    page.slug=slug
    # TODO parse the title from somewhere instead of this
    page.title = slug

    page
  end

  def save(access_token)
    # sync with github
    git = Git.open(@project.repo_path)  # TODO consider using the logger here
    git.branch('gh-pages').checkout
    git.pull("https://#{access_token}@github.com/#{user_name}/#{repo_name}.git", 'gh-pages')

    new_page=false

    # create the directory and manifest file
    unless File.exists?(jekyll_page_path)
      new_item=true
      write_file(jekyll_page_path, jekyll_page_contents)
    end

    git.add(jekyll_page_path)

    self.project.add_item(self)
    git.add(self.project.navigation_path)


    if new_item
      git.commit("Added #{@title}")
    else
      git.commit("Updated #{@title}")
    end      
    response = git.push("https://#{access_token}@github.com/#{user_name}/#{repo_name}.git", 'gh-pages')    
    true
  end

  def destroy(access_token)
    git = Git.open(@project.repo_path)  # TODO consider using the logger here
    git.branch('gh-pages').checkout
    git.pull("https://#{access_token}@github.com/#{user_name}/#{repo_name}.git", 'gh-pages')

    # remove everything in the item path under _data
    FileUtils.rm(jekyll_page_path)
    self.project.remove_item(self)
    git.add(self.project.navigation_path)

    # remove the same from the repository
    git.remove(jekyll_page_path, recursive: true)

    git.commit("Removed #{slug}")
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


  def jekyll_page_path
    File.join(@project.repo_path, 'pages', "#{slug}.md")
  end

  def jekyll_page_contents
    ApplicationController::render template: 'pages/jekyll_page.md', layout: false, locals: {page: self}
  end

  def slug=(slug)
    @slug=slug
  end

  def slug
    @slug || @title.gsub(/\W+/, '-').downcase
  end

  def project
    @project
  end

  def uri_root
    "#{@project.uri_root}/#{slug}"
  end

end