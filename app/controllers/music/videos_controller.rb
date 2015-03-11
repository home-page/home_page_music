class Music::VideosController < ApplicationController
  before_filter :show_breadcrumbs
  
  def index
    begin
      @videos = JSON.parse(
        HTTParty.get("#{Volontariat::HOSTS[Rails.env.to_s.to_sym]}/api/v1/users/#{Volontariat::USER_ID}/library/music/videos.json?page=#{params[:page]}").body
      )
    rescue JSON::ParserError
    end
    
    if @videos.nil?
      flash[:alert] = I18n.t('general.volontariat.request_failed')
      @videos = { 'entries' => [] }
    else
      @pagination = HomePage::PaginationMetadata.new(@videos)
    end
  end
  
  def resource
    @video
  end
end