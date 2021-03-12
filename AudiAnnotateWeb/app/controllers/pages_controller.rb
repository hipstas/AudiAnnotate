class PagesController < ApplicationController
  before_action :connect, only: [:create, :destroy, :edit, :show, :update]
  before_action :set_page, only: [:destroy, :edit, :show, :update]


  def show

  end

  def new
    @page = Page.new(params[:user_name], params[:repo_name])
  end

  def create

    @page = Page.new(
      page_params[:user_name], 
      page_params[:repo_name], 
      page_params[:title])

    respond_to do |format|
      if @page.save(session[:github_token])
        format.html { redirect_to page_path(@page.user_name, @page.repo_name, @page.slug), notice: 'Page stub was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end



  # GET /pages/1/edit
  def edit
  end


  # PATCH/PUT /pages/1
  # PATCH/PUT /pages/1.json
  def update
    @page.title = page_params[:title]

    respond_to do |format|
      if @page.save(session[:github_token])
        format.html { redirect_to page_path(@page.user_name, @page.repo_name, @page.slug), notice: 'page manifest was successfully updated.' }
        format.json { render :show, status: :ok, location: @page }
      else
        format.html { render :edit }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.json
  def destroy()
    @page.destroy(session[:github_token])
    respond_to do |format|
      format.html { redirect_to project_path(@page.user_name, @page.repo_name), notice: 'page was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_page
      @page = Page.from_file(params[:user_name], params[:repo_name], params[:slug])
      @project = @page.project
      if @github_client
        begin
          @pages_site_status = @github_client.pages("#{params[:user_name]}/#{params[:repo_name]}").status
        rescue Octokit::NotFound
          @pages_site_status = "Missing"
        end
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def page_params
      params.require(:page).permit(:title, :user_name, :repo_name)
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
