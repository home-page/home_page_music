class Music::HomeController < ApplicationController
  def index
    @home_page_stylesheets = ['home_page/application', 'vendors/keen/dashboards']
    @body_class = 'application'
    @user_name = Setting['home_page.apis.providers.lastfm.user_name']
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
  end
end