$(document).ready ->

  #get all the values from the Create micro filter form and stringify them (to be sent)
  aggregateCMValues = () ->
    microshelter = {}
    microshelter.name = $('#cmName').val()
    microshelter.capacity = $('#cmCapacity').val()
    microshelter.description = $('#cmCapacity').val()
    microshelter.lat = 23.3232
    microshelter.long = 73.2323
    JSON.stringify(microshelter)

  aggregateHValues = () ->
      pwnia = {}
      pwnia.name = $('#hName').val()
      pwnia.description = $('#hCapacity').val()
      pwnia.fl = $('#checkbox-2').is(":checked")
      pwnia.sf = $('#checkbox-3').is(":checked") 
      pwnia.el = $('#checkbox-4').is(":checked")
      pwnia.fi = $('#checkbox-5').is(":checked")
      pwnia.td = $('#checkbox-6').is(":checked")
      pwnia.sd = $('#checkbox-7').is(":checked")
      pwnia.lat = 23.3232
      pwnia.long = 73.2323
      JSON.stringify(pwnia)


  $('#submitHelp').on ('click'), ->
      $.mobile.loading('show', {
          text : 'submitting your request...',
          textVisible : true,
          theme : 'a',
          html : ""
      });  
      $.ajax 'https://api.mongolab.com/api/1/databases/sandy/collections/pwnia?apiKey=50958597e4b0268b29eee111',
          type: 'POST'
          contentType: 'application/json'
          data: aggregateHValues()
          error: (jqXHR, textStatus, errorThrown) ->
              alert "AJAX Error: #{textStatus}, #{errorThrown}"
          success: (data, textStatus, jqXHR) ->
              $.mobile.loading('hide')
              $("#hRequestInfo").popup("open")

  $('#submitCreateMicroFilter').on ('click'), ->
      $.mobile.loading('show', {
          text : 'submitting your request...',
          textVisible : true,
          theme : 'a',
          html : ""
      });  
      $.ajax 'https://api.mongolab.com/api/1/databases/sandy/collections/microshelters?apiKey=50958597e4b0268b29eee111',
          type: 'POST'
          contentType: 'application/json'
          data: aggregateCMValues()
          error: (jqXHR, textStatus, errorThrown) ->
              alert "AJAX Error: #{textStatus}, #{errorThrown}"
          success: (data, textStatus, jqXHR) ->
              $.mobile.loading('hide')
              $("#msRequestInfo").popup("open")

  $('#shelterButton').on ('click'), ->

      $.mobile.loading('show', 
          text : 'Loading shelters near you',
          textVisible : true,
          theme : 'a',
          html : ""
      )
        
      mapOptions = 
                zoom: 10,
                center: new google.maps.LatLng(40.716843, -73.989514),
                mapTypeId: google.maps.MapTypeId.ROADMAP
              
      map = new google.maps.Map(document.getElementById('map_canvas'), mapOptions)
      
      refreshMap = ->
        google.maps.event.trigger(map, 'resize') 
        map.panTo new google.maps.LatLng(40.716843, -73.989514)
          
      google.maps.event.addListenerOnce map, 'idle', refreshMap
      setTimeout refreshMap, 300
      
      $.getJSON 'https://api.mongolab.com/api/1/databases/sandy/collections/shelters?apiKey=50958597e4b0268b29eee111', (data) ->  
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