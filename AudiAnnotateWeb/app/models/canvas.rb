class Canvas
  attr_accessor :audio_url, :duration

  def initialize(item, audio_url, position, duration=100)
    @item=item
    @audio_url = audio_url
    @position = position
    @duration = duration
  end



  #######################
  # Manifest helpers
  #######################
  def slug
    "canvas-#{@position}"
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