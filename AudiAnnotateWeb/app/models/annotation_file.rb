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

  def detect_delimiter()
    tab_csv = CSV.read(File.join(parked_filepath, filename), col_sep: "\t", quote_char: "𒊬")
    comma_csv = CSV.read(File.join(parked_filepath, filename), col_sep: ",", quote_char: "𒊬")
    if tab_csv[0].size > 1
      "\t"
    elsif comma_csv[0].size > 1 
      ","
    else
      "not found" 
    end   
  end

  def sample_snippet()
    delimiter=detect_delimiter
    csv=CSV.read(File.join(parked_filepath, filename), col_sep: delimiter, quote_char: "𒊬")
    csv[0..10]
  end

  def save(access_token, config)
    csv = CSV.read(File.join(parked_filepath, filename), 
                    :col_sep => config[:col_sep], 
                    :quote_char => '"', 
                    :liberal_parsing => true)


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