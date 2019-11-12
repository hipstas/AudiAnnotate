class Annotation

  def initialize(json)
    @json = json
  end

  def text
    @json['body']['value']
  end


  def start_time
    @json['target']['selector']['t']
  end

  def end_time
    @json['target']['selector']['t']
  end

end