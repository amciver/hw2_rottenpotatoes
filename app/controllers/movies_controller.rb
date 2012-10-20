class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #set the listing of possible ratings
    @all_ratings = Movie.all_ratings

    #set the active ratings that are being used for filtering based on passed in params
    @active_ratings =  params[:ratings].nil? ? {} : params[:ratings]

    p "@active_ratings"
    p @active_ratings.inspect

    #get movies ordered by directional sort and by a given rating if applicable
    @movies = Movie.all(:order => params[:sort], :conditions => @active_ratings.blank? ? @active_ratings : {:rating => @active_ratings.keys})
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
