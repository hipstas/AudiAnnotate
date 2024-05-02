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
    #Dir.mkdir(@canvas.canvas_path) unless Dir.exists?(@canvas.canvas_path)
    #Dir.mkdir(parked_filepath) unless Dir.exists?(parked_filepath)
    FileUtils.mkdir_p(parked_filepath)
    @filename = parked_filename
    File.write(@filename,File.read(@uploaded_file))
  end

  def detect_delimiter()
    tab_csv = CSV.new(File.read(File.join(parked_filepath, filename)).gsub(/[\r\n]+/, "\n"), col_sep: "\t", quote_char: "𒊬").read
    comma_csv = CSV.new(File.read(File.join(parked_filepath, filename)).gsub(/[\r\n]+/, "\n"), col_sep: ",", quote_char: "𒊬").read
    if tab_csv[0].size > 1
      "\t"
    elsif comma_csv[0].size > 1 
      ","
    else
      "not found" 
    end   
  end

  def sample_snippet()
    csv=read_csv
    csv[0..10]
  end

  def is_xls?
    File.extname(filename) == '.xlsx' || File.extname(filename) == '.xls'
  end

  def is_cuepoint_xml?
    File.extname(filename) == '.xml'
  end

  def read_csv
    parked_file = File.join(parked_filepath, filename)
    if is_xls?
      roo_object = Roo::Spreadsheet.open(parked_file, extension: File.extname(filename).sub(".",""))
      raw_csv = roo_object.to_csv
      csv = CSV.new(raw_csv)
      csv_array = csv.read
    else
      csv_array = CSV.new(File.read(parked_file).gsub(/[\r\n]+/, "\n"), col_sep: detect_delimiter, quote_char: "𒊬").read
    end

    csv_array
  end

  def save_cuepoints(access_token)
    doc = Nokogiri::XML(File.read(filename))

    layers = {}
    ['Label','Note'].each do |layer|
      doc.search(layer).each do |element|
        layers[layer] ||= []
        parent = element.parent
        position = parent.search('Position').first.text
        sample_length = parent.search('SampleLength').first.text
        text = element.text
        layers[layer] << [position, sample_length, text]
      end
    end

    config = { start_col: 0, end_col: 1, text_col: 2, is_cuepoint: true}
    layers.each_pair do |layer_label, rows|
      page = AnnotationPage.from_csv(rows, config, layer_label, @canvas)
      page.create
    end

    @canvas.item.save(access_token)
  end



  def save(access_token, config)
    csv = read_csv

    if config[:headers]
      start_row = 1
    else
      start_row = 0
    end

    layers = {}
    if config[:layer_col].nil?
      layers[layer] = csv[start_row..]
    else
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
    if @uploaded_file.respond_to? :original_filename
      File.join(parked_filepath,Time.now.gmtime.iso8601.gsub(/\D/,"") + "_" + @uploaded_file.original_filename)
    else
      File.join(parked_filepath,@uploaded_file.path)
    end
  end

  def old_parked_filename
    File.join(old_parked_filepath,Time.now.gmtime.iso8601.gsub(/\D/,"") + "_" + @uploaded_file.original_filename)
  end

  def parked_filepath
    canvas_path = @canvas.canvas_path
    canvas_path.sub('_data', '_originals')
  end

  def old_parked_filepath
    File.join(@canvas.canvas_path, "originals")
  end

end