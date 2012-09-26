ko = window.ko
$ = window.jQuery
sf = window.sf

$(document).ready () ->

   class HomePageViewModel
      constructor: (data) ->
         styles = [
            "stylers": [
               "hue": "#ff0011"
               "saturation": 1 
               "lightness": 1
               "gamma": 1
            ]
         ]

         sfLatLng =  new google.maps.LatLng(sf.lat, sf.lng)

         mapOptions =
            center: sfLatLng
            zoom: 16
            mapTypeId: google.maps.MapTypeId.ROADMAP
            styles: styles

         map = new google.maps.Map $("#map").get(0), mapOptions

         sfPin = new google.maps.Marker
            position: sfLatLng
            map: map
            # icon: "/images/pin-sf.png"

   viewModel = new HomePageViewModel()
   ko.applyBindings viewModel

