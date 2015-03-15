class Music::VideosController < ApplicationController
  before_filter :show_breadcrumbs
  
  def index
    host = HomePage::ApiProviderHost.new('volontariat', Rails.env).to_s
    user_id = Setting['home_page.apis.providers.volontariat.user_id']
    
    begin
      @videos = JSON.parse(
        HTTParty.get("#{host}/api/v1/users/#{user_id}/library/music/videos.json?page=#{params[:page]}").body
      )
    rescue JSON::ParserError
    end
    
    if @videos.nil?
      flash[:alert] = I18n.t('general.apis.request_failed', provider: 'Volontari.at')
      @videos = { 'entries' => [] }
    else
      @pagination = HomePage::PaginationMetadata.new(@videos)
    end
  end
  
  def resource
    @video
  end
end