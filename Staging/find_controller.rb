class FindController < ApplicationController
  before_filter :create_user

  def find
    puts params.inspect
    puts @current_user.inspect
    if params[:product].nil?
      params[:product] = { :name => @current_user.product_selection }
      @bugs = Bug.search(params[:search], params[:product])
    else
      params[:product] = { :name => @current_user.product_selection }
      @bugs = Bug.search(params[:search], params[:product]['name'])
    end
    if params[:product].nil?
      params[:product] = { :name => @current_user.product_selection }
      @issues = Issue.search(params[:search], params[:product])
    else
      params[:product] = { :name => @current_user.product_selection }
      @issues = Issue.search(params[:search], params[:product]['name'])
    end
    if params[:product].nil?
      params[:product] = { :name => @current_user.product_selection }
      @fmrs = Fmr.search(params[:search], params[:product])
    else
      params[:product] = { :name => @current_user.product_selection }
      @fmrs = Fmr.search(params[:search], params[:product]['name'])
    end
    if params[:product].nil?
      params[:product] = { :name => @current_user.product_selection }
      @release_notes = ReleaseNote.search(params[:search], params[:product])
    else
      params[:product] = { :name => @current_user.product_selection }
      @release_notes = ReleaseNote.search(params[:search], params[:product]['name'])
    end
    if params[:product].nil?
      params[:product] = { :name => @current_user.product_selection }
      @versions = Version.search(params[:search], params[:product])
    else
      params[:product] = { :name => @current_user.product_selection }
      @versions = Version.search(params[:search], params[:product]['name'])
    end
      @tips = Tip.search(params[:search])
  end
end
