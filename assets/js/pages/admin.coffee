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
               @emitLatLng(pos.coords.latitude, pos.coords.longitude)
         
      switchTracking: () ->
         newValue = !@is_tracking()
         @is_tracking(newValue)
         @triggerUpdate()

      switchActive: () ->
         newValue = !@is_active()
         @is_active(newValue)
         socket.emit "active_change", 
            session_id: sf.connect_sid
            active: newValue

      emitLatLng: (lat, lng) ->
         socket.emit "location_change",
            session_id: sf.connect_sid
            lat: lat
            lng: lng

   viewModel = new AdminPageViewModel()
   ko.applyBindings viewModel