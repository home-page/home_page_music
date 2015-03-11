class Music::YearInReviewsController < ApplicationController
  before_filter :show_breadcrumbs
  
  def index
    begin
      @year_in_reviews = JSON.parse(
        HTTParty.get("#{Volontariat::HOSTS[Rails.env.to_s.to_sym]}/api/v1/users/#{Volontariat::USER_ID}/library/music/year_in_reviews.json?page=#{params[:page]}").body
      )
    rescue JSON::ParserError
    end
    
    if @year_in_reviews.nil?
      flash[:alert] = I18n.t('general.volontariat.request_failed')
      @year_in_reviews = { 'entries' => [] }
    else
      @pagination = HomePage::PaginationMetadata.new(@year_in_reviews)
    end
  end
  
  def show
    begin
      @year_in_review = JSON.parse(
        HTTParty.get("#{Volontariat::HOSTS[Rails.env.to_s.to_sym]}/api/v1/users/#{Volontariat::USER_ID}/library/music/year_in_reviews/#{params[:id]}.json").body
      )
    rescue JSON::ParserError
    end
    
    raise ActiveRecord::RecordNotFound if @year_in_review.nil?
  end
  
  def top_albums
    @year_in_review = { 'year' => params[:id] }
    
    begin
      @albums = JSON.parse(
        HTTParty.get("#{Volontariat::HOSTS[Rails.env.to_s.to_sym]}/api/v1/users/#{Volontariat::USER_ID}/library/music/year_in_reviews/#{params[:id]}/top_releases.json").body
      )
    rescue JSON::ParserError
    end
    
    raise ActiveRecord::RecordNotFound if @albums.nil?
  end
  
  def top_songs
    @year_in_review = { 'year' => params[:id] }
    
    begin
      @songs = JSON.parse(
        HTTParty.get("#{Volontariat::HOSTS[Rails.env.to_s.to_sym]}/api/v1/users/#{Volontariat::USER_ID}/library/music/year_in_reviews/#{params[:id]}/top_tracks.json").body
      )
    rescue JSON::ParserError
    end
    
    raise ActiveRecord::RecordNotFound if @songs.nil?
  end
  
  def resource
    @year_in_review
  end
end