require 'csv'
class TipsController < ApplicationController
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


  # GET /tips
  # GET /tips.json
  def index
    puts params.inspect
    if params[:format] == 'csv'
      generate_csv_headers("tips-#{Time.now.strftime("%Y%m%d")}.csv") 
    end
    if params[:product].nil?
      params[:product] = { :name => @current_user.product_selection }
    end
    @tips = Tip.all
    #if params[:product][:name] == "All" || params[:product][:name].nil?
    #  @tips = Tip.order(sort_column + " " + sort_direction)
    #else
    #  @tips = Tip.where(:product_family => params[:product][:name]).order(sort_column + " " + sort_direction)
    #end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tips }
      format.csv
    end
  end

  # GET /tips/1
  # GET /tips/1.json
  def show
    @tip = Tip.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tip }
    end
  end

  # GET /tips/new
  # GET /tips/new.json
  def new
    @tip = Tip.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tip }
    end
  end

  # GET /tips/1/edit
  def edit
    @tip = Tip.find(params[:id])
  end

  # POST /tips
  # POST /tips.json
  def create
    @tip = Tip.new(params[:tip])

    respond_to do |format|
      if @tip.save
        format.html { redirect_to @tip, notice: 'Tip was successfully created.' }
        format.json { render json: @tip, status: :created, location: @tip }
      else
        format.html { render action: "new" }
        format.json { render json: @tip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tips/1
  # PUT /tips/1.json
  def update
    @tip = Tip.find(params[:id])

    respond_to do |format|
      if @tip.update_attributes(params[:tip])
        format.html { redirect_to @tip, notice: 'Tip was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tips/1
  # DELETE /tips/1.json
  def destroy
    @tip = Tip.find(params[:id])
    @tip.destroy

    respond_to do |format|
      format.html { redirect_to tips_url }
      format.json { head :no_content }
    end
  end

  private
  
  def sort_column
      Tip.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
