class @SpotifyPlayerList
  constructor: ->
    window.spotify_player_list = {}
    
    $(document.body).on "click", ".spotify_player_list_item_play_button", (event) ->
      event.preventDefault()
      model = $(this).parents('.spotify_player_list_item').data('model')
      
      iframeHtml = if model == 'Track'
        '<iframe src="https://embed.spotify.com/?uri=spotify:track:' + $(this).data('spotify-id') + '&view=coverart" frameborder="0" allowtransparency="true" width="300" height="80"></iframe>'
      else
        '<iframe src="https://embed.spotify.com/?uri=spotify:album:' + $(this).data('spotify-id') + '" frameborder="0" allowtransparency="true" width="300" height="380"></iframe>'
       
      modalBodyHtml = """
<div class="modal-header">
  <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
  <h4 class="modal-title" id="myModalLabel">Play #{model}</h4>
</div>
<div class="modal-body" style="overflow-y:none;">
  #{iframeHtml}
</div>
<div class="modal-footer">
  <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
</div>
""" 
       
      $('.modal-content').html(modalBodyHtml)
      $('#modal').modal('show')

    musicResources = { track: [], release: [] }
    window.spotify_player_list.resourceToIndex = {}

    $.each $('.spotify_player_list_item'), (index, element) =>
      element = $(element)
      resource = { artist_name: element.data('artist-name'), name: element.data('name') }
      key = "#{element.data('model')}:#{element.data('artist-name')};#{element.data('name')}".toLowerCase()
      window.spotify_player_list.resourceToIndex[key] = [] if window.spotify_player_list.resourceToIndex[key] == undefined
      window.spotify_player_list.resourceToIndex[key].push index
      
      if element.data('model') == 'Track'
        musicResources['track'].push resource
      else
        musicResources['release'].push resource
    
    @bulkRequest(musicResources, ['Track', 'Release'])
  
  bulkRequest: (musicResources, models) -> 
    return if models.length == 0
    
    model = null
    resources = []
    resources_count = 0
    
    while resources_count == 0
      model = models.shift()
      window.spotify_player_list.model = model
      window.spotify_player_list.models = models
      
      resources = musicResources[model.toLowerCase()]  
      resources_count = resources.length
      
      break if resources_count > 0
      return if models.length == 0
    
    data = {}
     
    if model == 'Track'
      data['tracks'] = resources
    else
      data['releases'] = resources
      
    $.ajax(
      url: "#{volontariatHost}/api/v1/music/#{model.toLowerCase()}s/bulk",
      type: 'POST', dataType: 'json', data: data
    ).done((data) =>
      $.each data, (index, element) =>
        listItemIndexes = window.spotify_player_list.resourceToIndex["#{model}:#{element['artist_name']};#{element['name']}".toLowerCase()]
        
        $.each listItemIndexes, (index, listItemIndex) =>
          listItem = $('.spotify_player_list_item')[listItemIndex]
  
          unless element['spotify_id'] == null
            button = $(listItem).find('.spotify_player_list_item_play_icon')
            $(button).data('spotify-id', element['spotify_id'])
            $(button).addClass('spotify_player_list_item_play_button')
            $(button).removeClass('hide')
              
          $(listItem).find('.spotify_player_list_item_spinner').hide()
        
    ).fail((data) =>
      $.each $('.spotify_player_list_item'), (index, element) =>
        element = $(element)
        
        if element.data('model') == window.spotify_player_list.model
          listItemIndexes = window.spotify_player_list.resourceToIndex["#{model}:#{element.data('artist-name')};#{element.data('name')}".toLowerCase()]
          
          $.each listItemIndexes, (index, listItemIndex) =>
            listItem = $('.spotify_player_list_item')[listItemIndex]
            $(listItem).find('.spotify_player_list_item_spinner').replace('<strong style="color:red;">Loading failed!</strong>')
    ).always((data) =>
      @bulkRequest(musicResources, window.spotify_player_list.models) if models.length > 0
    )
      