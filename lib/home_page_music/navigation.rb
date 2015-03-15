module HomePageMusic
  module Navigation
    def self.menu_code(resource)
      case resource
      when 'music'
        Proc.new do |primary, options|
          primary.item :music, I18n.t('music.index.title'), music_path do |music|
            music.item :year_in_reviews, I18n.t('music_year_in_reviews.index.short_title'), music_year_in_reviews_path do |year_in_reviews|
              if @year_in_review.present?
                year_in_reviews.item :show, @year_in_review['year'], music_year_in_review_path(@year_in_review['year']) do |year_in_review|
                  year_in_review.item :top_albums, I18n.t('music_year_in_reviews.show.top_albums.short_title'), top_albums_music_year_in_review_path(@year_in_review['year'])  
                  year_in_review.item :top_songs, I18n.t('music_year_in_reviews.show.top_songs.short_title'), top_songs_music_year_in_review_path(@year_in_review['year'])  
                end
              end
            end
            
            music.item :videos, I18n.t('music_videos.index.short_title'), music_videos_path
          end
        end
      end
    end
  end
end
    