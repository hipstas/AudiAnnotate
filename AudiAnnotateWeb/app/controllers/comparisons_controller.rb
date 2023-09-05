class ComparisonsController < ApplicationController
  before_action :connect
  before_action :set_project
  before_action :set_comparison, only: %i[ show edit update destroy ]

  # GET /comparisons or /comparisons.json
  def index
    @comparisons = Comparison.all
  end

  # GET /comparisons/1 or /comparisons/1.json
  def show
  end

  # GET /comparisons/new
  def new
    # load the items to compare
    @items = @project.items
    @comparison = Comparison.new(@project.user_name, @project.repo_name)
  end

  # GET /comparisons/1/edit
  def edit
    @items = @project.items
  end

  # POST /comparisons or /comparisons.json
  def create
    @comparison = Comparison.new(
      comparison_params[:user_name], 
      comparison_params[:repo_name], 
      comparison_params[:label])
    @comparison.item_a = comparison_params[:item_a]
    @comparison.item_b = comparison_params[:item_b]
    respond_to do |format|
      if @comparison.save(session[:github_token])
        format.html { redirect_to comparison_path(@comparison.user_name, @comparison.repo_name, @comparison.slug), notice: 'Comparison page was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /comparisons/1 or /comparisons/1.json
  def update
    @comparison.label = comparison_params[:label]
    @comparison.item_a = comparison_params[:item_a]
    @comparison.item_b = comparison_params[:item_b]  
    respond_to do |format|
      if @comparison.save(session[:github_token])
        format.html { redirect_to comparison_url(@comparison.user_name, @comparison.repo_name, @comparison.slug), notice: "Comparison was successfully updated." }
        format.json { render :show, status: :ok, location: @comparison }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @comparison.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comparisons/1 or /comparisons/1.json
  def destroy
    @comparison.destroy(session[:github_token])

    respond_to do |format|
      format.html { redirect_to project_path(params[:user_name], params[:repo_name]), notice: "Comparison was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.new(params[:user_name], params[:repo_name])

      if @github_client
        begin
          @pages_site_status = @github_client.pages("#{params[:user_name]}/#{params[:repo_name]}").status  || "Missing"
        rescue Octokit::NotFound
          @pages_site_status = "Missing"
        end
      end
      @project = Project.new(params[:user_name], params[:repo_name])
    end


    def set_comparison
      @comparison = Comparison.from_file(params[:user_name], params[:repo_name], params[:slug])
    end

    # Only allow a list of trusted parameters through.
    def comparison_params
      params.require(:comparison).permit(:label, :item_a, :item_b, :slug, :repo_name, :user_name)
    end
end
