class Music::HomeController < ApplicationController
  def index
    @user_name = Setting['home_page.apis.providers.lastfm.user_name']
    
    if Setting['home_page.apis.providers.lastfm.key'].present? && @user_name.present?
      @home_page_stylesheets = ['home_page/application', 'vendors/keen/dashboards']
      @home_page_javascripts = ['home_page/application', 'home_page_music/application']
      @body_class = 'application'
      
      [:recent_tracks, :artists, :releases, :tracks].each do |data_type|
        begin
          case data_type
          when :recent_tracks
            @recent_tracks = HomePageMusic::Api::LastfmRequest.new(
              :user, :get_recent_tracks, nil, user: @user_name, limit: 4, extended: 1
            ).response
          when :artists
            @artists = HomePageMusic::Api::LastfmRequest.new(
              :user, :get_top_artists, nil, user: @user_name, limit: 10
            ).response
          when :releases
            @releases = HomePageMusic::Api::LastfmRequest.new(
              :user, :get_top_albums, nil, user: @user_name, limit: 10
            ).response
          when :tracks
            @tracks = HomePageMusic::Api::LastfmRequest.new(
              :user, :get_top_tracks, nil, user: @user_name, limit: 10
            ).response
          end
        rescue StandardError => e
          ::Airbrake.notify e if Rails.env.production?
        end
      end
      
      render layout: 'fluid/without_rows'
    else
      flash[:alert] = t('general.apis.settings_missing', provider: 'last.fm') if user_signed_in?
      render text: '', layout: 'application'
    end
  end
end