class AnnotationPage

  def initialize(canvas, page_path)
    @canvas = canvas
    @page = JSON.load(File.open(page_path))
  end

  def label
    @page['label']
  end

  def annotations
    @page['items'].map { |anno| Annotation.new(anno) }
  end

end