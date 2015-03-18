class Music::HomeController < ApplicationController
  def index
    @user_name = Setting['home_page.apis.providers.lastfm.user_name']
    
    if Setting['home_page.apis.providers.lastfm.key'].present? && @user_name.present?
      @home_page_stylesheets = ['home_page/application', 'vendors/keen/dashboards']
      @body_class = 'application'
      @recent_tracks = HomePageMusic::Api::LastfmRequest.new(
        :user, :get_recent_tracks, nil, user: @user_name, limit: 4, extended: 1
      ).response
      @artists = HomePageMusic::Api::LastfmRequest.new(
        :user, :get_top_artists, nil, user: @user_name, limit: 10
      ).response
      @releases = HomePageMusic::Api::LastfmRequest.new(
        :user, :get_top_albums, nil, user: @user_name, limit: 10
      ).response
      @tracks = HomePageMusic::Api::LastfmRequest.new(
        :user, :get_top_tracks, nil, user: @user_name, limit: 10
      ).response
      
      render layout: 'fluid/without_rows'
    else
      flash[:alert] = t('general.apis.settings_missing', provider: 'last.fm') if user_signed_in?
      render text: '', layout: 'application'
    end
  end
end