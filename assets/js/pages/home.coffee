ko = window.ko
$ = window.jQuery
sf = window.sf
socket = window.io.connect window.location.origin

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
         @watching_location = false
         @show_about = ko.observable false
         @about_text = ko.computed () => if @show_about() then "Close" else "About"

         @sf_active = ko.observable sf.active
         @sf_inactive = ko.computed () => return !@sf_active()
         @user_latlng = null
         @user_pin = null
         @user_distance = ko.observable("Unknown")
         @sf_latlng = mapOptions.center = new google.maps.LatLng(sf.lat, sf.lng)
         @map = new google.maps.Map $("#map").get(0), mapOptions

         @sf_pin = new google.maps.Marker
            position: @sf_latlng
            map: @map
            icon: "/images/pin-sf.png"
            shadow: "/images/pin-shadow-sf.png"

         @user_distance_text = ko.computed () =>
            unless @sf_active() then return ""
            else if @user_distance() == "Unknown"
               return "Not sure where you're at!"
            return textForDistance @user_distance()

         @setLocationWatch();
         @sf_pin.setVisible @sf_active()

         socket.on "location_update", (data) =>
            if data then @setSfLatLng(data.lat, data.lng)

         socket.on "active_update", (data) =>
            if data then @sf_active(data.active)
            @setLocationWatch()

         @sf_active.subscribe (active) =>
            @sf_pin.setVisible active

      setLocationWatch: () ->
         if navigator?.geolocation and @sf_active() and not @watching_location
            navigator.geolocation.watchPosition (pos) =>
               @setUserLatLng(pos.coords.latitude, pos.coords.longitude)
               @watching_location = true;

      setSfLatLng: (lat, lng) ->
         @sf_latlng = new google.maps.LatLng(lat, lng)
         @calculateDistance()
         @sf_pin.setPosition @sf_latlng

      setUserLatLng: (lat, lng) ->
         @user_latlng = new google.maps.LatLng(lat, lng);
         @calculateDistance()
         if @user_pin
            @user_pin.setPosition @user_latlng
         else
            @user_pin = new google.maps.Marker
               position: @user_latlng
               map: @map

      calculateDistance: () ->
         if @user_latlng and @sf_latlng
            @user_distance(Math.round google.maps.geometry.spherical.computeDistanceBetween(@user_latlng, @sf_latlng))
         else
            @user_distance("Unknown")

      showHideAbout: () ->
         @show_about(!@show_about())

   ko.bindingHandlers.fadeIn = 
      update: (element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) ->
         valueUnwrapped = ko.utils.unwrapObservable(valueAccessor())
         duration = allBindingsAccessor().duration || 400
         if valueUnwrapped == true
            $(element).fadeIn(duration)
         else
            $(element).fadeOut(duration)

   ko.bindingHandlers.slideDown = 
      init: (element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) ->
         valueUnwrapped = ko.utils.unwrapObservable(valueAccessor())
         $el = $(element)
         if valueUnwrapped == true
            $el.show().css("top", 0)
         else
            $el.css("top", -1 * $el.height()).show()
      update: (element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) ->
         valueUnwrapped = ko.utils.unwrapObservable(valueAccessor())
         duration = allBindingsAccessor().duration || 400
         $el = $(element)
         if valueUnwrapped == true
            $el.animate(top: 0, duration)
         else
            $el.animate(top: -1*$el.height(), duration)

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