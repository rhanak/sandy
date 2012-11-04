$(document).ready ->
  
  aggregateHValues = (lat, long) ->
      pwnia = {}
      pwnia.name = $('#hName').val()
      pwnia.description = $('#hDescription').val()
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
                  $('#PWNIAButton').trigger('click')
                  $.mobile.changePage "#helpMePage", 
                           transition : "slide"

                setTimeout changePage, 2000
  
  # share this map instance across instantiations    
  mapOptions = 
            mapTypeId: google.maps.MapTypeId.ROADMAP
          
  map = new google.maps.Map(document.getElementById('help_map_canvas'), mapOptions)
  
  $('#PWNIAButton').on ('click'), ->

      $.mobile.loading('show', 
          text : 'Loading people in need near you',
          textVisible : true,
          theme : 'a',
          html : ""
      );
  
      
      bounds = new google.maps.LatLngBounds()
      
      refreshMap = ->
        google.maps.event.trigger(map, 'resize') 
        map.setCenter bounds.getCenter()
        map.fitBounds bounds 
        
      google.maps.event.addListenerOnce map, 'idle', refreshMap
      setTimeout refreshMap, 300
      
      infowindow = new google.maps.InfoWindow
      
      jqXHR = $.getJSON 'https://api.mongolab.com/api/1/databases/sandy/collections/pwnia?apiKey=50958597e4b0268b29eee111', (data) ->  
                $.each data, (i, help) ->
                    latLng = new google.maps.LatLng(help.lat, help.long)
                    bounds.extend latLng
                    letterNumber = "A".charCodeAt(0) + (i % 25)
                    letter = String.fromCharCode(letterNumber)
                    marker = new google.maps.Marker
                        map:map,
                        animation: google.maps.Animation.DROP,
                        position: latLng
                        icon: "img/markers/red_Marker#{letter}.png"
                      
                    google.maps.event.addListener marker, 'click', ->
                        help.description = "" unless help.description
                        infowindow.setContent "<strong>#{help.name}</strong> <br/> <ul> #{getPwniaTypes(help)} </ul> <i>#{help.description}</i>"     
                        infowindow.open(map,marker)
                        
      jqXHR.complete ->
        setTimeout refreshMap, 300
        
      getPwniaTypes = (help) ->
        types = ""
        types += "<li>Flooding</li>" if help.fl
        types += "<li>Shortage of food</li>" if help.sf
        types += "<li>Electricity</li>" if help.el
        types += "<li>Fire</li>" if help.fi
        types += "<li>Tree Down</li>" if help.td
        types += "<li>Structurial Damage</li>" if help.sd
        types

                  

        
        
       
      
 
     
    

       

      
      
                         
      
      
      
      
