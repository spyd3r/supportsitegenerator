require 'csv'
class VersionsController < ApplicationController
  helper_method :sort_column, :sort_direction
  load_and_authorize_resource
  before_filter :create_user

 def generate_csv_headers(filename)
    headers.merge!({
      'Cache-Control'             => 'must-revalidate, post-check=0, pre-check=0',
      'Content-Type'              => 'text/csv',
      'Content-Disposition'       => "attachment; filename=\"#{filename}\"",
      'Content-Transfer-Encoding' => 'binary'
    })
  end


  # GET /versions
  # GET /versions.json
  def index
    puts params.inspect
    if params[:format] == 'csv'
      generate_csv_headers("version_info-#{Time.now.strftime("%Y%m%d")}.csv") 
    end
    if params[:product].nil?
      params[:product] = { :name => @current_user.product_selection }
    end
    if params[:product]['name'] == "All" || params[:product].nil?
      @versions = Version.order(sort_column + " " + sort_direction)
    else
      @versions = Version.where(:product_family => params[:product]['name']).order(sort_column + " " + sort_direction)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @versions }
      format.csv
    end
  end

  # GET /versions/1
  # GET /versions/1.json
  def show
    @version = Version.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @version }
    end
  end

  # GET /versions/new
  # GET /versions/new.json
  def new
    @version = Version.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @version }
    end
  end

  # GET /versions/1/edit
  def edit
    @version = Version.find(params[:id])
  end

  # POST /versions
  # POST /versions.json
  def create
    @version = Version.new(params[:version])

    respond_to do |format|
      if @version.save
        format.html { redirect_to @version, notice: 'Version was successfully created.' }
        format.json { render json: @version, status: :created, location: @version }
      else
        format.html { render action: "new" }
        format.json { render json: @version.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /versions/1
  # PUT /versions/1.json
  def update
    @version = Version.find(params[:id])

    respond_to do |format|
      if @version.update_attributes(params[:version])
        format.html { redirect_to @version, notice: 'Version was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @version.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /versions/1
  # DELETE /versions/1.json
  def destroy
    @version = Version.find(params[:id])
    @version.destroy

    respond_to do |format|
      format.html { redirect_to versions_url }
      format.json { head :no_content }
    end
  end

  private

  def sort_column
      Bug.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

end
