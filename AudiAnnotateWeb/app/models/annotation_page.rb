class AnnotationPage

PROTOTYPE = <<EOF
{
  "@context": "http://iiif.io/api/presentation/3/context.json",
  "id": "https://example.org/iiif/book1/annotation/p0001-image",
  "type": "Annotation",
  "motivation": "painting",
  "body": {
    "id": "https://example.org/images/page1.jpg",
    "type": "Image"
  },
  "target": "https://example.org/iiif/book1/canvas/p1"
}
EOF


  #############################################
  # Methods to READ an annotation page
  #############################################
  def initialize(canvas, page_path=nil)
    @canvas = canvas
    if page_path
      @page = JSON.load(File.open(page_path))
    end
  end

  def label
    if @label
      @label
    else
      if @page['label'].is_a? String
        @page['label']
      else
        @page['label'].values.first.join("\n")
      end
    end
  end

  def label=(label)
    @label = label
  end

  def page=(page)
    @page = page
  end

  def annotations
    @page['items'].map { |anno| Annotation.new(anno) }
  end

  def annotation_page_uri
    @page['id']
  end

  def rows=(rows)
    @rows=rows
  end

  def config=(config)
    @config=config
  end

  #############################################
  # Methods to WRITE an annotation page
  #############################################
  def self.from_csv(rows, config, label, canvas)
    Dir.mkdir(canvas.canvas_path) unless Dir.exists?(canvas.canvas_path)

    page = AnnotationPage.new(canvas)
    page.label=label
    page.rows=rows
    page.config=config

    page
  end


  def self.from_external(json, canvas)
    page = AnnotationPage.new(canvas)
    page.page = json

    page
  end

  def create
    Dir.mkdir(@canvas.canvas_path) unless Dir.exists?(@canvas.canvas_path)

    File.write(annotation_page_file_path, page_contents(@rows, @config))
  end

  def self.label_to_slug(label)

  end


  def seconds_from_raw(raw, config)
    if md=raw.match(/(\d\d);(\d\d);(\d\d);(\d\d)/)
      #this is adobe premiere export format
      seconds=0.0
      seconds += md[1].to_i*60*60 #take hours convert to seconds
      seconds += md[2].to_i*60 #take minutes convert to seconds
      seconds += md[3].to_i #add seconds
      seconds += md[4].to_f/100 #add hundreths of seconds
      seconds.to_s
    elsif md=raw.match(/(\d+:)?(\d+):(\d+)(\.\d+)?/)
      seconds = 0.0
      seconds += md[1].gsub(/\D/,'').to_i*60*60 if md[1] #take hours convert to seconds
      seconds += md[2].to_i*60 #take minutes convert to seconds
      seconds += md[3].to_i #add seconds
      seconds += md[4].to_f if md[4]
      seconds.to_s
    elsif md=raw.match(/^\d+$/) && config[:is_cuepoint]
      # BWF MetaEdit frame
      seconds = raw.to_f / 44100
      seconds.to_s
    else
      raw
    end
  end

  def page_contents(csv=nil, config=nil)
    if csv # only generate from a csv if we have one
      page = {
        "@context": "http://iiif.io/api/presentation/3/context.json",
        "id": "#{annotation_page_uri}",
        "type": "AnnotationPage",
        "label": @label
      }

      items = []
      csv.each_with_index do |row, i|
        next if row == [] || (i==0 && config[:headers])
        wa = JSON.parse(PROTOTYPE)
        # set the constants
        wa["@context"] = "http://www.w3.org/ns/anno.jsonld"
        wa["motivation"]=["supplementing", "commenting"]
        body = { "type" => "TextualBody", "value" => row[config[:text_col]], "format" => "text/plain" }
        wa["body"] = body
        start_seconds=seconds_from_raw(row[config[:start_col]], config)
        if row[config[:end_col]].blank?
          end_seconds=start_seconds
        else
          end_seconds=seconds_from_raw(row[config[:end_col]], config)
        end
        # parse them into seconds
        if start_seconds==end_seconds
          # point selection
          selector = { "type" => "PointSelector", "t" => start_seconds }
        else
          # range selection
          selector = {"type" => "RangeSelector", "t" => "#{start_seconds},#{end_seconds}" }
        end
        wa["id"] = annotation_uri(i)
        wa["target"] = { "source" => @canvas.canvas_id, "selector" => selector }
        items << wa
      end

      page['items'] = items

      JSON.pretty_generate(page)
    else
      JSON.pretty_generate(@page)
    end
  end

  def destroy(access_token)
    File.unlink(annotation_page_file_path)
    @canvas.item.save(access_token)
  end


  #######################
  # Manifest helpers
  #######################
  def slug
    if @page.nil? || @page['id'].match(@canvas.canvas_id)
      label.gsub(/\W/, '-').downcase
    else
      @page['id'].gsub(/\W/, '_')
    end
  end

  def annotation_page_file_path
    File.join(@canvas.canvas_path, annotation_page_file)
  end

  def annotation_page_file
    "#{slug}.json"
  end

  # def uri_root
  #   "#{@item.uri_root}/#{slug}"
  # end

  def annotation_page_uri
    "#{@canvas.canvas_id}/#{slug}.json"
  end

  def annotation_uri(index)
    "#{@canvas.canvas_id}/#{slug}-annotation-#{index}.json"
  end



end