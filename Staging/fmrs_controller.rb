require 'csv'
class FmrsController < ApplicationController
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


  # GET /fmrs
  # GET /fmrs.json
  def index
    puts params.inspect
    if params[:format] == 'csv'
      generate_csv_headers("fmrs-#{Time.now.strftime("%Y%m%d")}.csv") 
    end
    if params[:product].nil?
      params[:product] = { :name => @current_user.product_selection }
    end
    if params[:product]['name'] == "All" || params[:product].nil?
      @fmrs = Fmr.order(sort_column + " " + sort_direction)
    else
      @fmrs = Fmr.where(:product_family => params[:product]['name']).order(sort_column + " " + sort_direction)
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @fmrs }
      format.csv
    end
  end

  # GET /fmrs/1
  # GET /fmrs/1.json
  def show
    @fmr = Fmr.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @fmr }
    end
  end

  # GET /fmrs/new
  # GET /fmrs/new.json
  def new
    @fmr = Fmr.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @fmr }
    end
  end

  # GET /fmrs/1/edit
  def edit
    @fmr = Fmr.find(params[:id])
  end

  # POST /fmrs
  # POST /fmrs.json
  def create
    @fmr = Fmr.new(params[:fmr])

    respond_to do |format|
      if @fmr.save
        format.html { redirect_to @fmr, notice: 'Fmr was successfully created.' }
        format.json { render json: @fmr, status: :created, location: @fmr }
      else
        format.html { render action: "new" }
        format.json { render json: @fmr.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /fmrs/1
  # PUT /fmrs/1.json
  def update
    @fmr = Fmr.find(params[:id])

    respond_to do |format|
      if @fmr.update_attributes(params[:fmr])
        format.html { redirect_to @fmr, notice: 'Fmr was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @fmr.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fmrs/1
  # DELETE /fmrs/1.json
  def destroy
    @fmr = Fmr.find(params[:id])
    @fmr.destroy

    respond_to do |format|
      format.html { redirect_to fmrs_url }
      format.json { head :no_content }
    end
  end
  
  private
  
  def sort_column
      Fmr.column_names.include?(params[:sort]) ? params[:sort] : "number"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
