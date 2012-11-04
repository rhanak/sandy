( ->
  Sandy.getLocation = (success) ->
    navigator.geolocation.getCurrentPosition(success, onError);

  # onError Callback receives a PositionError object
  #
  onError = (error) ->
      alert('Could not get you location!' + 
            'code: '    + error.code    + '\n' +
            'message: ' + error.message + '\n')
)()

