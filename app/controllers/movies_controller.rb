class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = Movie.ratings
    @sort = params[:sort]
    @selectedRatings = params[:ratings]

    if (@sort!=nil && @selectedRatings!={})
	flash.keep
	@movies =  Movie.where(:rating => @selectedRatings.keys).order(@sort + ' ASC')
    end
 
    if @selectedRatings!=nil
	    session[:savedRatings] = @selectedRatings
	    if (session[:savedSortVal]!=nil)
	    	@movies = Movie.where(:rating => @selectedRatings.keys).order(session[:savedSortVal] + ' ASC')
	    else
		@movies = Movie.where(:rating => @selectedRatings.keys)
	    end
    else
	@selectedRatings = {}
    end

    if @sort!=nil
	session[:savedSortVal] = @sort
	if @selectedRatings!={}
	    @movies = Movie.where(:rating => @selectedRatings.keys).order(@sort + ' ASC')
	else
	    @movies = Movie.order(@sort + ' ASC')
	end
    end

    if (@sort==nil && @selectedRatings=={} && (session[:savedSortVal]!=nil or session[:savedRatings]!=nil))
	flash.keep
	redirect_to movies_path(:sort => session[:savedSortVal], :ratings => session[:savedRatings])
    end

    @movies
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
