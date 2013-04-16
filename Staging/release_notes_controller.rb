require 'csv'
class ReleaseNotesController < ApplicationController
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


  # GET /release_notes
  # GET /release_notes.json
  def index
    puts params.inspect
    if params[:format] == 'csv'
      generate_csv_headers("release_notes-#{Time.now.strftime("%Y%m%d")}.csv") 
    end
    if params[:product].nil?
      params[:product] = { :name => @current_user.product_selection }
    end
    if params[:product]['name'] == "All" || params[:product].nil?
      @release_notes = ReleaseNote.order(sort_column + " " + sort_direction)
    else
      @release_notes = ReleaseNote.where(:product_family => params[:product]['name']).order(sort_column + " " + sort_direction)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @release_notes }
      format.csv
    end
  end

  # GET /release_notes/1
  # GET /release_notes/1.json
  def show
    @release_note = ReleaseNote.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @release_note }
    end
  end

  # GET /release_notes/new
  # GET /release_notes/new.json
  def new
    @release_note = ReleaseNote.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @release_note }
    end
  end

  # GET /release_notes/1/edit
  def edit
    @release_note = ReleaseNote.find(params[:id])
  end

  # POST /release_notes
  # POST /release_notes.json
  def create
    @release_note = ReleaseNote.new(params[:release_note])

    respond_to do |format|
      if @release_note.save
        format.html { redirect_to @release_note, notice: 'Release note was successfully created.' }
        format.json { render json: @release_note, status: :created, location: @release_note }
      else
        format.html { render action: "new" }
        format.json { render json: @release_note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /release_notes/1
  # PUT /release_notes/1.json
  def update
    @release_note = ReleaseNote.find(params[:id])

    respond_to do |format|
      if @release_note.update_attributes(params[:release_note])
        format.html { redirect_to @release_note, notice: 'Release note was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @release_note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /release_notes/1
  # DELETE /release_notes/1.json
  def destroy
    @release_note = ReleaseNote.find(params[:id])
    @release_note.destroy

    respond_to do |format|
      format.html { redirect_to release_notes_url }
      format.json { head :no_content }
    end
  end
  
  private
  
  def sort_column
      ReleaseNote.column_names.include?(params[:sort]) ? params[:sort] : "kb"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
