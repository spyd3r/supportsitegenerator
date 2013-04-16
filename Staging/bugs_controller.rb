require 'csv'
class BugsController < ApplicationController
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
  


  # GET /bugs
  # GET /bugs.json
  def index
    puts @current_user.inspect
    puts request.remote_ip
    if params[:format] == 'csv'
      generate_csv_headers("bugs-#{Time.now.strftime("%Y%m%d")}.csv") 
    end
    if params[:product].nil?
      params[:product] = { :name => @current_user.product_selection }
    end
    puts params.inspect
    @bugs = Bug.order(sort_column + " " + sort_direction)
    if params[:product]['name'] == "All" || params[:product].nil?
      @bugs = Bug.order(sort_column + " " + sort_direction)
    else
      @bugs = Bug.where(:product_family => params[:product]['name']).order(sort_column + " " + sort_direction)
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bugs }
      format.csv #index.csv.erb
    end
  end

  # GET /bugs/1
  # GET /bugs/1.json
  def show
    @bug = Bug.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bug }
    end
  end

  # GET /bugs/new
  # GET /bugs/new.json
  def new
    @bug = Bug.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bug }
    end
  end

  # GET /bugs/1/edit
  def edit
    @bug = Bug.find(params[:id])
  end

  # POST /bugs
  # POST /bugs.json
  def create
    @bug = Bug.new(params[:bug])

    respond_to do |format|
      if @bug.save
        format.html { redirect_to @bug, notice: 'Bug was successfully created.' }
        format.json { render json: @bug, status: :created, location: @bug }
      else
        format.html { render action: "new" }
        format.json { render json: @bug.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /bugs/1
  # PUT /bugs/1.json
  def update
    @bug = Bug.find(params[:id])

    respond_to do |format|
      if @bug.update_attributes(params[:bug])
        format.html { redirect_to @bug, notice: 'Bug was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @bug.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bugs/1
  # DELETE /bugs/1.json
  def destroy
    @bug = Bug.find(params[:id])
    @bug.destroy

    respond_to do |format|
      format.html { redirect_to bugs_url }
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
