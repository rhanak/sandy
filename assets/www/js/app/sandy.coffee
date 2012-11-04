$(document).ready ->

  #get all the values from the Create micro filter form and stringify them (to be sent)
  aggregateCMValues = (lat, long) ->
    microshelter = {}
    microshelter.name = $('#cmName').val()
    microshelter.capacity = $('#cmCapacity').val()
    microshelter.description = $('#cmCapacity').val()
    microshelter.lat = lat
    microshelter.long = long
    JSON.stringify(microshelter)

  $('#submitCreateMicroFilter').on ('click'), ->
      $.mobile.loading('show', {
          text : 'submitting your request...',
          textVisible : true,
          theme : 'a',
          html : ""
      }); 
      
      Sandy.getLocation (position) ->
        $.ajax 'https://api.mongolab.com/api/1/databases/sandy/collections/microshelters?apiKey=50958597e4b0268b29eee111',
            type: 'POST'
            contentType: 'application/json'
            data: aggregateCMValues(position.coords.latitude, position.coords.longitude)
            error: (jqXHR, textStatus, errorThrown) ->
                alert "AJAX Error: #{textStatus}, #{errorThrown}"
            success: (data, textStatus, jqXHR) ->
                $.mobile.loading('hide')
                $("#msRequestInfo").popup("open")
  
  loadMap = ->
    bounds = new google.maps.LatLngBounds()
    
    refreshMap = ->
      google.maps.event.trigger(map, 'resize')
      map.setCenter bounds.getCenter()
      map.fitBounds bounds
        
    google.maps.event.addListenerOnce map, 'idle', refreshMap
    setTimeout refreshMap, 300
    
    infowindow = new google.maps.InfoWindow
    
    $.getJSON 'https://api.mongolab.com/api/1/databases/sandy/collections/shelters?apiKey=50958597e4b0268b29eee111', (data) ->  
            $.each data, (i, help) ->
                latLng = new google.maps.LatLng(help.lat, help.long)
                bounds.extend latLng
                letterNumber = "A".charCodeAt(0) + (i % 25)
                letter = String.fromCharCode(letterNumber)
                marker = new google.maps.Marker
                    map:map,
                    animation: google.maps.Animation.DROP,
                    position: latLng
                    icon: "img/markers/blue_Marker#{letter}.png"

                google.maps.event.addListener marker, 'click', -> 
                    infowindow.setContent "<strong>#{help.popserved}</strong>"      
                    infowindow.open(map,marker)
  
  # share this map instance across instantiations    
  mapOptions = 
            mapTypeId: google.maps.MapTypeId.ROADMAP
          
  map = new google.maps.Map(document.getElementById('map_canvas'), mapOptions)
  
  loadMap()
  
  $('#shelterButton').on ('click'), ->

      $.mobile.loading('show', 
          text : 'Loading shelters near you',
          textVisible : true,
          theme : 'a',
          html : ""
      )
       
      loadMap() 
      