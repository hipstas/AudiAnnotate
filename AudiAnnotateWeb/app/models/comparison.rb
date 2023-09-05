class Comparison
  include ActiveModel::Model
  attr_accessor :label, :slug, :user_name, :repo_name, :item_a, :item_b

  def initialize(user_name, repo_name, label=nil)
    @project = Project.new(user_name, repo_name)
    @label=label
  end    

  def self.from_file(user_name, repo_name, slug)
    comparison = Comparison.new(user_name, repo_name)
    comparison.slug=slug
    yaml = YAML.load(File.read(comparison.jekyll_page_path))
    comparison.label=yaml['title']
    comparison.item_a=yaml['item_a']
    comparison.item_b=yaml['item_b']

    comparison
  end

  def write_file(path, contents)
    FileUtils.mkdir_p(File.dirname(path))
    File.write(path,contents)
  end

  # TODO for comparison
  def save(access_token)
    # sync with github
    git = Git.open(@project.repo_path)
    git.branch('gh-pages').checkout
    git.pull("https://#{access_token}@github.com/#{user_name}/#{repo_name}.git", 'gh-pages')

    new_item = !File.exists?(jekyll_page_path)

    # create the directory and manifest file
    write_file(jekyll_page_path, jekyll_page_contents)

    self.project.add_comparison(self)
    git.add(self.project.navigation_path)

    # add, commit, and push
    git.add(jekyll_page_path)
    if new_item
      git.commit("Added comparison #{slug}")
    else
      unless git.status.changed.empty?
        git.commit("Updated comparison #{slug}")
      end
    end      
    response = git.push("https://#{access_token}@github.com/#{user_name}/#{repo_name}.git", 'gh-pages')    

    true
  end


  def destroy(access_token)
    git = Git.open(@project.repo_path)  # TODO consider using the logger here
    git.branch('gh-pages').checkout
    git.pull("https://#{access_token}@github.com/#{user_name}/#{repo_name}.git", 'gh-pages')

    FileUtils.rm(jekyll_page_path)
    git.remove(jekyll_page_path, recursive: true)

    self.project.remove_item(self)
    git.add(self.project.navigation_path)

    git.commit("Removed #{label}")
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
    ApplicationController::render template: 'comparisons/jekyll_comparison.md', layout: false, locals: {frontmatter: frontmatter}
  end

  def frontmatter
    {
      'layout' => 'comparison',
      'title' => label,
      'permalink' => slug,
      'item_a' => item_a,
      'item_b' => item_b
    }
  end

  def slug=(slug)
    @slug=slug
  end

  def slug
    @slug || label.gsub(/\W+/, '-').downcase
  end

  def uri_root
    "#{@project.uri_root}/#{slug}"
  end


  def project
    @project
  end
end