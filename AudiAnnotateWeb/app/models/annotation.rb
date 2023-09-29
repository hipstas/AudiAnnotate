class Annotation

  def initialize(json)
    @json = json
  end

  def text
    body = @json['body']
    if body.is_a? Hash
      body = [body]
    end
    body.select{|e| e['purpose'] == 'commenting'}.map {|e| e['value']}.join("\n")
  end

  def terms
    body = @json['body']
    if body.is_a? Hash
      body = [body]
    end
    body.select{|e| e['purpose'] == 'tagging'}.map {|e| e['value']}
  end

  def start_time
    if @json['target'].is_a? String
      fragment = @json['target'].split('#')[1]
      # md = fragment.match /t=([0-9.]+),?([0-9.]+)?/
      md = fragment.match /t=([0-9.,]+)?/
      if md
        md[1]
      else
        'BAD FRAGMENT'
      end
    else
      @json['target']['selector']['t']
    end
  end

  def end_time
    @json['target']['selector']['t']
  end

end