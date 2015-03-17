if Setting.table_exists? && !Setting['home_page.general.plugins'].include?('home_page_music')
  Setting['home_page.general.plugins'] = Setting['home_page.general.plugins'] + ['home_page_music']
end

Setting.defaults['home_page_music.general.available_apis'] = ['lastfm']

# cannot be set to false yet for the time being without text logic
Setting.defaults['home_page.apis.providers.lastfm.user_name'] = ''
Setting.defaults['home_page.apis.providers.lastfm.charts.types.recent_tracks.is_image'] = true
Setting.defaults['home_page.apis.providers.lastfm.charts.types.recent_tracks.design'] = 'TBM-RecentTracks2'
Setting.defaults['home_page.apis.providers.lastfm.charts.types.recent_tracks.tracks_count'] = 6
Setting.defaults['home_page.apis.providers.lastfm.key'] = ''
Setting.defaults['home_page.apis.providers.lastfm.secret'] = ''
