class Canvas
  attr_accessor :audio_url, :duration, :position

  def initialize(item, audio_url, position, duration)
    @item=item
    @audio_url = audio_url
    @position = position
    @duration = duration
  end

  def annotation_pages
    folders = Dir.glob(File.join(canvas_path, "*"))
    folders.delete_if{|name| File.basename(name)=="originals"}
    folders.map{|folder| AnnotationPage.new(self, folder)}
  end

  def annotation_files
    files = Dir.glob(File.join(canvas_path, "originals", "*"))
    files.map{|fullpath| File.basename(fullpath)}.sort
  end

  def item
    @item
  end

  def save
    # create a subdirectory for this canvase
    unless Dir.exists?(canvas_path)
      Dir.mkdir(canvas_path)
    end

    # save any annotation pages
    annotation_pages.each { |page| page.save }  

  end

  #######################
  # Manifest helpers
  #######################
  def slug
    "canvas-#{@position}"
  end

  def canvas_path
    File.join(@item.item_path, slug)
  end

  def uri_root
    "#{@item.uri_root}/#{slug}"
  end

  def canvas_id
    "#{uri_root}/canvas"
  end

  def painting_annotation_id
    "#{uri_root}/painting"
  end

  def painting_annotation_page_id
    "#{uri_root}/paintings"
  end




end