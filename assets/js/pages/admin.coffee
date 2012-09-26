ko = window.ko
$ = window.jQuery
sf = window.sf
socket = window.io.connect window.location.origin

$(document).ready () ->

   class AdminPageViewModel
      constructor: (data) ->
         @is_tracking = ko.observable false
         @track_class = ko.computed () => if @is_tracking() then "active" else "inactive"
         @track_text = ko.computed () => if @is_tracking() then "Stop Tracking" else "Start Tracking"
         @is_active = ko.observable(sf.active or false)
         @active_class = ko.computed () => if @is_active() then "active" else "inactive"
         @active_text = ko.computed () => if @is_active() then "Close Stand" else "Open Stand"
         
         if navigator?.geolocation
            navigator.geolocation.watchPosition (pos) =>
               @setLatLng(pos)
               if @user_pin
                  @user_pin.setPosition @user_latlng
               else
                  @user_pin = new google.maps.Marker
                     position: @user_latlng
                     map: @map

      switchTracking: () ->
         newValue = !@is_tracking()
         @is_tracking(newValue)
         socket.emit "tracking_switch", tracking: newValue

      switchActive: () ->
         newValue = !@is_active()
         @is_active(newValue)
         socket.emit "active_switch", active: newValue

      setLatLng: (position) ->
         # @user_lat(position.coords.latitude)
         # @user_lng(position.coords.longitude)
         # @user_latlng = new google.maps.LatLng(@user_lat(), @user_lng());
         # @user_distance(Math.round google.maps.geometry.spherical.computeDistanceBetween(@user_latlng, @sf_latlng))


   viewModel = new AdminPageViewModel()
   ko.applyBindings viewModel