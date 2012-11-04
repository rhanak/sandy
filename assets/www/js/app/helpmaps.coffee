$(document).ready ->

  $('#helpButton').on ('click'), ->

      $.mobile.loading('show', 
          text : 'Loading people in need near you',
          textVisible : true,
          theme : 'a',
          html : ""
      );
      mylocation = null
      Sandy.getLocation (position) ->
        mylocation = new google.maps.LatLng position.coords.latitude, position.coords.longitude
        personNeedhelp = 
          'lat': position.coords.latitude
          'long': position.coords.longitude 
          
        $.ajax 'https://api.mongolab.com/api/1/databases/sandy/collections/pwnia?apiKey=50958597e4b0268b29eee111',
               type: 'POST'
               contentType: 'application/json'
               data: JSON.stringify(personNeedhelp)
               error: (jqXHR, textStatus, errorThrown) ->
                   alert "AJAX Error: #{textStatus}, #{errorThrown}"
               success: (data, textStatus, jqXHR) ->
                   $.mobile.loading('hide')

      mapOptions = 
                zoom: 13,
                center: new google.maps.LatLng(40.875323, -73.893512),
                mapTypeId: google.maps.MapTypeId.ROADMAP
              
      map = new google.maps.Map(document.getElementById('help_map_canvas'), mapOptions)
        
      refreshMap = ->
        google.maps.event.trigger(map, 'resize') 
        if mylocation?
          map.panTo mylocation
          
      google.maps.event.addListenerOnce map, 'idle', refreshMap
      setTimeout refreshMap, 300
      
      $.getJSON 'https://api.mongolab.com/api/1/databases/sandy/collections/pwnia?apiKey=50958597e4b0268b29eee111', (data) ->  
              $.each data, (i, help) ->
                  latLng = new google.maps.LatLng(help.lat, help.long)
                  marker = new google.maps.Marker
                      map:map,
                      animation: google.maps.Animation.DROP,
                      position: latLng
                  
                  infowindow = new google.maps.InfoWindow
                      content: help.popserved     
                  google.maps.event.addListener marker, 'click', ->      
                      infowindow.open(map,marker)
                  
                  mylocation = latLng if i is 0

        
        
       
      
 
     
    

       

      
      
                         
      
      
      
      
