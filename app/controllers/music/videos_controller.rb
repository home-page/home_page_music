class Music::VideosController < ApplicationController
  before_filter :show_breadcrumbs, :volontariat_connection
  
  def index
    if @host.blank? || @user_id < 1
      flash[:alert] = I18n.t('general.apis.settings_missing', provider: 'Volontari.at') if user_signed_in?
      @videos = { 'entries' => [] }
    else
      begin
        @videos = JSON.parse(
          HTTParty.get("#{@host}/api/v1/users/#{@user_id}/library/music/videos.json?page=#{params[:page]}").body
        )
      rescue JSON::ParserError
      end
      
      if @videos.nil? || !@videos.has_key?('entries')
        flash[:alert] = I18n.t('general.apis.request_failed', provider: 'Volontari.at')
        @videos = { 'entries' => [] }
      else
        @pagination = HomePage::PaginationMetadata.new(@videos)
      end
    end
  end
  
  def resource
    @video
  end
  
  private
  
  def volontariat_connection
    @host = HomePage::ApiProviderHost.new('volontariat', Rails.env).to_s
    @user_id = Setting['home_page.apis.providers.volontariat.user_id']
  end
end