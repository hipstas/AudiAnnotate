class AnnotationFile
  attr_accessor :layer, :filename, :canvas, :layer

  def initialize(canvas=nil, layer=nil, uploaded_file=nil)
    @canvas = canvas
    @uploaded_file = uploaded_file
    @layer = layer
  end

  def self.from_file(canvas, layer, basename)
    file = AnnotationFile.new
    file.canvas = canvas
    file.layer = layer
    file.filename = basename

    file
  end

  def park(access_token)
    Dir.mkdir(@canvas.canvas_path) unless Dir.exists?(@canvas.canvas_path)
    Dir.mkdir(parked_filepath) unless Dir.exists?(parked_filepath)
    @filename = parked_filename
    File.write(@filename,File.read(@uploaded_file))
  end

  def save(access_token)
    # TODO validation
    config = {}
    begin
      csv = CSV.read(File.join(parked_filepath, filename), col_sep: "\t", quote_char: "𒊬") # people may use double-quotes but should not be annotating in cuneiform
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

      contents = File.read(File.join(parked_filepath, filename))
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
      csv = CSV.read(File.join(parked_filepath, filename), 
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

  def filename
    @filename
  end

  def basename
    File.basename(@filename)
  end

  def parked_filename
    File.join(parked_filepath,Time.now.gmtime.iso8601.gsub(/\D/,"") + "_" + @uploaded_file.original_filename)
  end

  def parked_filepath
    File.join(@canvas.canvas_path, "originals")
  end

end