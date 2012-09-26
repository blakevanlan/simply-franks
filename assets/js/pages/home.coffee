ko = window.ko
$ = window.jQuery
sf = window.sf

mapOptions = 
   zoom: 15
   mapTypeId: google.maps.MapTypeId.ROADMAP
   styles: [
      "stylers": [
         "hue": "#ff0011"
         "saturation": 1 
         "lightness": 1
         "gamma": 1
         ]
      ]

$(document).ready () ->

   class HomePageViewModel
      constructor: (data) ->
         
         @user_lat = ko.observable()
         @user_lng = ko.observable()
         @user_latlng = null
         @user_pin = null
         @user_distance = ko.observable("Unknown")
         @sf_latlng = mapOptions.center = new google.maps.LatLng(sf.lat, sf.lng)
         @map = new google.maps.Map $("#map").get(0), mapOptions
         @sf_pin = new google.maps.Marker
            position: @sf_latlng
            map: @map
            icon: "/images/pin-sf.png"

         @user_distance_text = ko.computed () =>
            if @user_distance() == "Unknown"
               return "No sure where your at!"
            return textForDistance @user_distance()

         if navigator?.geolocation
            navigator.geolocation.watchPosition (pos) =>
               @setLatLng(pos)
               if @user_pin
                  @user_pin.setPosition @user_latlng
               else
                  @user_pin = new google.maps.Marker
                     position: @user_latlng
                     map: @map

      setLatLng: (position) ->
         @user_lat(position.coords.latitude)
         @user_lng(position.coords.longitude)
         @user_latlng = new google.maps.LatLng(@user_lat(), @user_lng());
         @user_distance(Math.round google.maps.geometry.spherical.computeDistanceBetween(@user_latlng, @sf_latlng))

   viewModel = new HomePageViewModel()
   ko.applyBindings viewModel

textForDistance = (distance) ->
   if distance < 100
      feet = Math.round(distance * 3.28084)
      return "Only <span class='ft close'>#{feet} ft</span> away!";
   else
      miles = Math.round(100*(distance / 1609.34))/100

      if miles < 1.5
         return "Only <span class='mi close'>#{miles} mi</span> away!"
      else
         return "Jump in the car! Just <span class='mi'>#{miles} mi</span> away!"