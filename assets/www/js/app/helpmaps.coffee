$(document).ready ->
  
  aggregateHValues = (lat, long) ->
      pwnia = {}
      pwnia.name = $('#hName').val()
      pwnia.description = $('#hCapacity').val()
      pwnia.fl = $('#checkbox-2').is(":checked")
      pwnia.sf = $('#checkbox-3').is(":checked") 
      pwnia.el = $('#checkbox-4').is(":checked")
      pwnia.fi = $('#checkbox-5').is(":checked")
      pwnia.td = $('#checkbox-6').is(":checked")
      pwnia.sd = $('#checkbox-7').is(":checked")
      pwnia.lat = lat
      pwnia.long = long
      JSON.stringify(pwnia)
      
  $('#submitHelp').on ('click'), ->
      $.mobile.loading('show', {
          text : 'submitting your request...',
          textVisible : true,
          theme : 'a',
          html : ""
      });  
      Sandy.getLocation (position) ->
        $.ajax 'https://api.mongolab.com/api/1/databases/sandy/collections/pwnia?apiKey=50958597e4b0268b29eee111',
            type: 'POST'
            contentType: 'application/json'
            data: aggregateHValues(position.coords.latitude, position.coords.longitude)
            error: (jqXHR, textStatus, errorThrown) ->
                alert "AJAX Error: #{textStatus}, #{errorThrown}"
            success: (data, textStatus, jqXHR) ->
                $.mobile.loading('hide')
                $("#hRequestInfo").popup("open")
                changePage = ->
                  # Load the page when the button is clicked  
                  $('#helpButton').trigger('click')
                  $.mobile.changePage "#helpMePage", 
                           transition : "slide"

                setTimeout changePage, 2000
                
              
              
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

        
        
       
      
 
     
    

       

      
      
                         
      
      
      
      
