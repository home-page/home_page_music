class Music::YearInReviewsController < ApplicationController
  before_filter :show_breadcrumbs
  
  before_filter :volontariat_connection
  
  def index
    if @host.blank? || @user_id < 1
      flash[:alert] = I18n.t('general.apis.settings_missing', provider: 'Volontari.at') if user_signed_in?
      @year_in_reviews = { 'entries' => [] }
    else
      begin
        @year_in_reviews = JSON.parse(
          HTTParty.get("#{@host}/api/v1/users/#{@user_id}/library/music/year_in_reviews.json?page=#{params[:page]}").body
        )
      rescue JSON::ParserError
      end
      
      if @year_in_reviews.nil? || !@year_in_reviews.has_key?('entries')
        flash[:alert] = I18n.t('general.apis.request_failed', provider: 'Volontari.at')
        @year_in_reviews = { 'entries' => [] }
      else
        @pagination = HomePage::PaginationMetadata.new(@year_in_reviews)
      end
    end
  end
  
  def show
    unless @host.blank? || @user_id.blank?
      begin
        @year_in_review = JSON.parse(
          HTTParty.get("#{@host}/api/v1/users/#{@user_id}/library/music/year_in_reviews/#{params[:id]}.json").body
        )
      rescue JSON::ParserError
      end
    end
    
    raise ActiveRecord::RecordNotFound if @year_in_review.nil?
  end
  
  def top_albums
    @home_page_javascripts = ['home_page/application', 'home_page_music/application']
    
    unless @host.blank? || @user_id.blank?
      @year_in_review = { 'year' => params[:id] }
      
      begin
        @albums = JSON.parse(
          HTTParty.get("#{@host}/api/v1/users/#{@user_id}/library/music/year_in_reviews/#{params[:id]}/top_releases.json").body
        )
      rescue JSON::ParserError
      end
    end
    
    raise ActiveRecord::RecordNotFound if @albums.nil?
  end
  
  def top_songs
    @home_page_javascripts = ['home_page/application', 'home_page_music/application']
    
    unless @host.blank? || @user_id.blank?
      @year_in_review = { 'year' => params[:id] }
      
      begin
        @songs = JSON.parse(
          HTTParty.get("#{@host}/api/v1/users/#{@user_id}/library/music/year_in_reviews/#{params[:id]}/top_tracks.json").body
        )
      rescue JSON::ParserError
      end
    end
    
    raise ActiveRecord::RecordNotFound if @songs.nil?
  end
  
  def resource
    @year_in_review
  end
  
  private
  
  def volontariat_connection
    @host = HomePage::ApiProviderHost.new('volontariat', Rails.env).to_s
    @user_id = Setting['home_page.apis.providers.volontariat.user_id']
  end
end