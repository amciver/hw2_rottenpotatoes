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

    #p "params[:ratings]"
    #p params[:ratings].inspect

    if params[:ratings].blank?
      @active_ratings = session[:ratings].blank? ? @all_ratings.each { |rating| rating  } : session[:ratings]
      if !flash[:notice].blank?
        flash.keep(:notice)
      end
      redirect_to movies_path(:sort=> session[:sort], :ratings => @active_ratings)
    elsif params[:ratings].is_a?(Hash)
       @active_ratings = params[:ratings].keys
    else
       @active_ratings = params[:ratings]
    end
    #set the session data  for ratings for use later
    session[:ratings] = @active_ratings

    #p "@active_ratings"
    #p @active_ratings.inspect

    if params[:sort].blank?
      @active_sort = session[:sort]
    else
      @active_sort = params[:sort]
    end
    #set the sort data in the session for use later
    session[:sort] = @active_sort

    #get movies ordered by directional sort and by a given rating if applicable
    @movies = Movie.all(:order => @active_sort, :conditions => {:rating => @active_ratings})
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
