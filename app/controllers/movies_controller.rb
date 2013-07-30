class MoviesController < ApplicationController
    # @oldratings

  def initialize
	@all_rat = Movie.ratings
	@all_rat.each do |rat|
		(@ratings ||= { })[rat] = 1
	end
	super
  end
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    redirect = false
	if params[:s]
		@sorting = params[:s]
#	elsif session[:s]
	else
		@sorting = session[:s]
		redirect = true
	# else
		# @sorting = session[:s]
	end

	if params[:ratings]
		@ratings = params[:ratings]
	# elsif session[:ratings]
	else
		@ratings = session[:ratings]
		redirect = true
	# else
		# @ratings = session[:ratings]
	end

	if redirect
	  redirect_to movies_path(:s => @sorting, :ratings => @ratings)
	end
# debugger
    Movie.find(:all, :order => @sorting ? @sorting : :id).each do |mv|
	  if @ratings.keys.include? mv[:rating]
	    (@movies ||= [ ]) << mv
	  end
	end
	
    session[:ratings] = @ratings
    session[:s] = @sorting

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
