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
    csv = CSV.open(@uploaded_file, col_sep: "\t")

    Dir.mkdir(@canvas.canvas_path) unless Dir.exists?(@canvas.canvas_path)
    File.write(annotation_page_file_path, page_contents(csv))

    @canvas.item.save(access_token)
  end

  def page_contents(csv)
    page = {
      "@context": "http://iiif.io/api/presentation/3/context.json",
      "id": "#{annotation_page_uri}",
      "type": "AnnotationPage",
      "label": @layer
    }

    items = []

    csv.each_with_index do |row, i|
      wa = JSON.parse(PROTOTYPE)
      # set the constants
      wa["@context"] = "http://www.w3.org/ns/anno.jsonld"
      wa["motivation"]=["supplementing", "commenting"]
      body = { "type" => "TextualBody", "value" => row[2], "format" => "text/plain" }
      wa["body"] = body
      # TODO if on point vs range
      if row[0]==row[1]
        # point selection
        selector = { "type" => "PointSelector", "t" => row[0] }
      else
        # range selection
        selector = {"type" => "RangeSelector", "t" => "#{row[0]},#{row[1]}" }
      end
      wa["id"] = annotation_uri(i)
      wa["target"] = { "source" => @canvas.canvas_id, "selector" => selector }
      items << wa
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
    "page-#{slug}.json"
  end

  # def uri_root
  #   "#{@item.uri_root}/#{slug}"
  # end

  def annotation_page_uri
    "#{@canvas.canvas_id}/page-#{slug}.json"
  end

  def annotation_uri(index)
    "#{@canvas.canvas_id}/page-#{slug}-annotation-#{index}.json"
  end




end