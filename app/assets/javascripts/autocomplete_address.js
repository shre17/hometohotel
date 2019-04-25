function initMap() {
  var map = new google.maps.Map(document.getElementById('map'), {
    center: {lat: 37.0902, lng: 95.7129},
    zoom: 13
  });
  var card = document.getElementById('pac-card');
  var input = document.getElementById('pac-input');
  map.controls[google.maps.ControlPosition.TOP_RIGHT].push(card);

  var autocomplete = new google.maps.places.Autocomplete(input);
  autocomplete.bindTo('bounds', map);
  autocomplete.setFields(
      ['address_components', 'geometry', 'icon', 'name']);
  var infowindow = new google.maps.InfoWindow();
  var infowindowContent = document.getElementById('infowindow-content');
  infowindow.setContent(infowindowContent);
  var marker = new google.maps.Marker({
    map: map,
    anchorPoint: new google.maps.Point(0, -29)
  });
  autocomplete.addListener('place_changed', function() {
    infowindow.close();
    marker.setVisible(false);
    var place = autocomplete.getPlace();
    if (!place.geometry) {
      window.alert("No details available for input: '" + place.name + "'");
      return;
    }
    if (place.geometry.viewport) {
      map.fitBounds(place.geometry.viewport);
    } else {
      map.setCenter(place.geometry.location);
      map.setZoom(15);
    }
    marker.setPosition(place.geometry.location);
    marker.setVisible(true);

    var address = '';
    if (place.address_components) {
      $(".locations_other_fields").removeClass("d-none");
      $("#pac-input").prop("readonly",true);
      $(".next-button").prop("disabled",false);
      $(".wrong-address").addClass("d-none");
      $(".correct-address").removeClass("d-none");
      var add_length = place.address_components.length;
      var zip_code = parseInt(place.address_components[add_length-1].short_name);
      var country = place.address_components[add_length-2].long_name;
      var community = place.address_components[add_length-3].long_name;
      var state = place.address_components[add_length-4].long_name;
      var city = place.address_components[add_length-5].short_name;
      var latitude = place.geometry.location.lat();
      var longitude = place.geometry.location.lng();
      if (isNaN(zip_code) == true) {
        zip_code = "";
      }
      // $("#administrative_area_level_1").val(state);
      $("#country").val(country);
      $("#state").val(state);
      $("#locality").val(city);
      $("#postal_code").val(zip_code);
      $("#street_number").val(place.name);
      $("#latitude").val(latitude);
      $("#longitude").val(longitude);
      address = [
        (place.address_components[0] && place.address_components[0].short_name || ''),
        (place.address_components[1] && place.address_components[1].short_name || ''),
        (place.address_components[2] && place.address_components[2].short_name || '')
      ].join(' ');
    }
    infowindowContent.children['place-icon'].src = place.icon;
    infowindowContent.children['place-name'].textContent = place.name;
    infowindowContent.children['place-address'].textContent = address;
    infowindow.open(map, marker);
  });
}