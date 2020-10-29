class AnnotationFile
  attr_accessor :layer

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
      # configuration specific to Audacity uploads
      config = {
        col_sep: "\t",
        layer_col: nil,
        text_col: 2,
        start_col: 0,
        end_col: 1,
        headers: false
      }
    rescue

      contents = File.read(@uploaded_file)
      detection = CharlockHolmes::EncodingDetector.detect(contents)

      # configuration specific to Adobe Premiere
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


      # TODO store config in first-class object project wide (to be filled in
      # by an import wizard)
      csv = CSV.read(@uploaded_file, 
                      :encoding => "bom|#{detection[:encoding]}",
                      :col_sep => config[:col_sep], 
                      :quote_char => '"', 
                      :liberal_parsing => true)
    end


    layers = {}
    if config[:layer_col].nil?
      layers[layer] = csv
    else
      if config[:headers]
        start_row = 1
      else
        start_row = 0
      end
      labels = csv[start_row..].map{|row| row[config[:layer_col]]}.sort.uniq
      labels.each do |label|
        # find each subset of rows
        target_rows = csv.dup.keep_if{|row| row[config[:layer_col]] == label}
        # create a layer for each label and subset of rows
        layers[label] = target_rows
      end

    end

    layers.each_pair do |layer_label, rows|
      page = AnnotationPage.from_csv(rows, config, layer_label, @canvas)
      page.create
    end


    @canvas.item.save(access_token)
  end

  def destroy(access_token)
    File.unlink(annotation_page_file_path)
    @canvas.item.save(access_token)
  end




end