class AnnotationFile
  attr_accessor :layer



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


  def initialize(canvas, layer, uploaded_file)
    @canvas = canvas
    @uploaded_file = uploaded_file
    @layer = layer
  end


  def save(access_token)
    # TODO validation
    config = {}
    begin
      csv = CSV.read(@uploaded_file, col_sep: "\t", quote_char: "𒊬") # people may use double-quotes but should not be annotating in cuneiform
      config = {
        col_sep: ",",
        layer_col: nil,
        text_col: 2,
        start_col: 0,
        end_col: 1,
        headers: false
      }
    rescue

      contents = File.read(@uploaded_file)
      detection = CharlockHolmes::EncodingDetector.detect(contents)
      config = {
        col_sep: "\t",
        layer_col: 0,
        text_col: 1,
        start_col: 2,
        end_col: 3,
        headers: true
      }

      # to figure out quote string an delimiter, consider testing whether
      # csv.map { |r| r.count }.max == csv.map { |r| r.count }.in
      # to see whether the results of csv parsing are rectangular or jagged

      # TODO map layer label column, aggregate into a loop and write
      # multiple files

      # TODO differentiate between slug and label

      # TODO store config in first-class object project wide (to be filled in
      # by an import wizard)
      csv = CSV.read("../../scratch/Camille 1921 annotations.csv", 
                      :encoding => "bom|#{detection[:encoding]}",
                      :col_sep => "\t", 
                      :quote_char => '"', 
                      :liberal_parsing => true)
    end

    Dir.mkdir(@canvas.canvas_path) unless Dir.exists?(@canvas.canvas_path)
    File.write(annotation_page_file_path, page_contents(csv, config))

    @canvas.item.save(access_token)
  end

  def destroy(access_token)
    File.unlink(annotation_page_file_path)
    @canvas.item.save(access_token)
  end

  def seconds_from_raw(raw)
    if md=raw.match(/(\d\d);(\d\d);(\d\d);(\d\d)/)
      #this is adobe premiere export format
      seconds=0.0
      seconds += md[1].to_i*60*60 #take hours convert to seconds
      seconds += md[2].to_i*60 #take minutes convert to seconds
      seconds += md[3].to_i #add seconds
      seconds += md[4].to_f/100 #add hundreths of seconds
      seconds.to_s
    else
      raw
    end
  end

  def page_contents(csv, config)
    page = {
      "@context": "http://iiif.io/api/presentation/3/context.json",
      "id": "#{annotation_page_uri}",
      "type": "AnnotationPage",
      "label": @layer
    }

    items = []
    csv.each_with_index do |row, i|
      unless config[:headers] && i==0
        wa = JSON.parse(PROTOTYPE)
        # set the constants
        wa["@context"] = "http://www.w3.org/ns/anno.jsonld"
        wa["motivation"]=["supplementing", "commenting"]
        body = { "type" => "TextualBody", "value" => row[config[:text_col]], "format" => "text/plain" }
        wa["body"] = body
        # TODO if on point vs range
        # pull row[0] and row[1] into variables
        row0=seconds_from_raw(row[config[:start_col]])
        row1=seconds_from_raw(row[config[:end_col]])
        # parse them into seconds
        if row0==row1
          # point selection
          selector = { "type" => "PointSelector", "t" => row0 }
        else
          # range selection
          selector = {"type" => "RangeSelector", "t" => "#{row0},#{row1}" }
        end
        wa["id"] = annotation_uri(i)
        wa["target"] = { "source" => @canvas.canvas_id, "selector" => selector }
        items << wa
      end
    end

    page['items'] = items

    JSON.pretty_generate(page)
  end



  #######################
  # Manifest helpers
  #######################
  def slug
    layer.gsub(/\W/, '-')
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