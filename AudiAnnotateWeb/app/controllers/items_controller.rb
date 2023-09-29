class ItemsController < ApplicationController
  before_action :connect, only: [:add_annotation_file, :create, :destroy, :edit, :show, :update, :delete_annotation_layer, :configure_annotation_file, :process_annotation_file, :delete_annotation_file, :import_external_annotations, :review_external_annotations]
  before_action :set_item, only: [:add_annotation_file, :destroy, :edit, :update, :delete_annotation_layer, :download_annotation_file, :configure_annotation_file, :process_annotation_file, :delete_annotation_file, :review_external_annotations, :import_external_annotations, :delete_all_layers]

  # GET /items
  # GET /items.json
  def index
    @items = Item.all
  end

  # GET /items/1
  # GET /items/1.json
  def show
    if Dir.exist?(Item.new(params[:user_name], params[:repo_name], params[:slug]).item_path)
      set_item
    else
      redirect_to page_path(params[:user_name], params[:repo_name], params[:slug])
      return
    end
  end

  # GET /items/new
  def new
    @item = Item.new(params[:user_name], params[:repo_name])
  end

  def new_import
    @item = Item.new(params[:user_name], params[:repo_name])
  end

  def import_manifest
    @item = Item.from_url(
      item_params[:user_name], 
      item_params[:repo_name], 
      item_params[:manifest_url]
    )

    # TODO what should the slug be?

    # test that the manifest is resolvable and is JSON and is a IIIF manifest within the save method
    respond_to do |format|
      if @item.save(session[:github_token])
        format.html { redirect_to item_path(@item.user_name, @item.repo_name, @item.slug), notice: 'Item manifest was successfully imported.' }
      else
        format.html { render :new_import }
      end
    end
  end


  # POST /items
  # POST /items.json
  def create
    @item = Item.new(
      item_params[:user_name], 
      item_params[:repo_name], 
      item_params[:label], 
      item_params[:audio_url], 
      duration_to_seconds(item_params[:duration]),
      item_params[:provider_uri],
      item_params[:provider_label],
      item_params[:homepage])

    respond_to do |format|
      if @item.save(session[:github_token])
        format.html { redirect_to item_path(@item.user_name, @item.repo_name, @item.slug), notice: 'Item manifest was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end


  def add_annotation_file
    annotation_file = AnnotationFile.new(@item.canvases.first, item_params[:layer], item_params[:annotation_file])
    annotation_file.park(session[:github_token])
    if annotation_file.is_cuepoint_xml?
      annotation_file.save_cuepoints(session[:github_token])
      redirect_to item_path(@item.user_name, @item.repo_name, @item.slug)      
    else
      redirect_to configure_annotation_file_path(@item.user_name, @item.repo_name, @item.slug, annotation_file.basename)
    end
  end    

  def process_annotation_file
    annotation_file = AnnotationFile.from_file(
      @item.canvases.first, 
      params[:item][:layer_label], 
      params[:annotation_file_basename])

    if params[:has_layer_column] == "No"
      layer_column = nil
    else
      layer_column = params[:layer_column].to_i
    end

    if params[:has_index_column] == "No"
      index_column = nil
    else
      index_column = params[:index_column].to_i
    end

    config = {
      layer_col: layer_column,
      index_col: index_column,
      text_col: params[:annotation].to_i,
      start_col: params[:start_time].to_i,
      end_col: params[:end_time].to_i,
      headers: params[:headers]=="1"
    }
    if annotation_file.save(session[:github_token], config)
      redirect_to item_path(@item.user_name, @item.repo_name, @item.slug)
    end
  end    

  def delete_annotation_layer
    canvas = @item.canvases.first
    layer = canvas.annotation_pages.detect{|page| page.label == params[:layer] }
    layer.destroy(session[:github_token])
    redirect_to item_path(@item.user_name, @item.repo_name, @item.slug)
  end

  def delete_all_layers
    canvas = @item.canvases.first
    canvas.annotation_pages.each do |layer|
      layer.destroy(session[:github_token])
    end
    redirect_to item_path(@item.user_name, @item.repo_name, @item.slug)
  end

  def download_annotation_file
    canvas = @item.canvases.first
    file = params[:file]
    if File.exist?(File.join(canvas.canvas_path, "originals", file))
      send_file(File.join(canvas.canvas_path, "originals", file), filename: file)
    else
      send_file(File.join(canvas.canvas_path.sub("_data","_originals"), file), filename: file)
    end
  end

  def delete_annotation_file
    canvas = @item.canvases.first
    file = params[:file]
    if File.exist?(File.join(canvas.canvas_path, "originals", file))
      File.unlink(File.join(canvas.canvas_path, "originals", file))
    else
      File.unlink(File.join(canvas.canvas_path.sub("_data","_originals"), file))
    end
    redirect_to item_path(@item.user_name, @item.repo_name, @item.slug)    
  end

  def configure_annotation_file
    @canvas = @item.canvases.first
    @file = params[:file]
    @annotation_file = AnnotationFile.from_file(@item.canvases.first, nil, params[:file])
  end

  # GET /items/1/edit
  def edit
  end


  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    @item.label = item_params[:label]
    @item.audio_url = item_params[:audio_url]
    @item.duration = duration_to_seconds(item_params[:duration])
    @item.provider_uri = item_params[:provider_uri]
    @item.provider_label = item_params[:provider_label]
    @item.homepage = item_params[:homepage]

    respond_to do |format|
      if @item.save(session[:github_token])
        format.html { redirect_to item_path(@item.user_name, @item.repo_name, @item.slug), notice: 'Item manifest was successfully updated.' }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy()
    @item.destroy(session[:github_token])
    respond_to do |format|
      format.html { redirect_to project_path(@item.user_name, @item.repo_name), notice: 'Item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def review_external_annotations
    # find the link to the annotations within the manifest
    at_id = Base64.decode64 params[:at_id]
    external_annotation_pages = @item.manifest_json['items'].first['annotations']
    @external_annotation_page = dereference_page(external_annotation_pages.detect { |page| page['id'] == at_id})
  end

  def import_external_annotations
    # find the link to the annotations within the manifest
    at_id = Base64.decode64 params[:at_id]    
    external_annotation_pages = @item.manifest_json['items'].first['annotations']
    @external_annotation_page = dereference_page(external_annotation_pages.detect { |page| page['id'] == at_id})
    # if the link has a body, use it -- otherwise dereference the annotation page
    page = AnnotationPage.from_external(@external_annotation_page, @item.canvases.first) #, @canvas)
    page.create
    @item.save(session[:github_token])


    render action: 'show'
  end

  private
    def dereference_page(external_annotation_page)
      # if the link has a body, use it -- otherwise dereference the annotation page
      if external_annotation_page['items'].nil?
        # import the file from the net
        raw_page = URI.open(external_annotation_page['id']).read
        # parse the file
        JSON.parse(raw_page)
      else
        external_annotation_page
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.from_file(params[:user_name], params[:repo_name], params[:slug])
      @project = @item.project
      if @github_client
        begin
          @pages_site_status = @github_client.pages("#{params[:user_name]}/#{params[:repo_name]}").status  || "Missing"
        rescue Octokit::NotFound
          @pages_site_status = "Missing"
        end
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:label, :audio_url, :user_name, :repo_name, :duration, :layer, :annotation_file, :provider_uri, :provider_label, :homepage, :manifest_url)
    end

    def duration_to_seconds(duration)
      md = duration.match(/(\d+):(\d+):(\S+)/)
      if md
        duration = md[1].to_f * 60 * 60
        duration += md[2].to_f * 60
        duration += md[3].to_f
      elsif md = duration.match(/(\d+):(\S+)/)
        duration = md[1].to_f * 60
        duration += md[2].to_f 
      end
      duration  
    end

end
