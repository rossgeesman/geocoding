/* custom JavaScript goes here */

function objectifyForm(formArray) {
  var toReturn = {};
  formArray.forEach(
    function(input) {
      toReturn[input['name']] = input['value']
  })
  return toReturn;
}

function getAddress(coordinates) {
  let myHeaders = new Headers({
    'Accept': 'application/json',
    'Content-Type': 'application/json'
  });

  return fetch('/address', { method: 'POST', body: JSON.stringify(coordinates), headers: myHeaders})
  .then(function(response) {
    return response.json().then(function(data) {
      return data;
    })
  })
}

function addressListItem(address) {
  return "<li class='list-group-item'>" +
    address['address'] +
    "<br> Distance to Whitehouse: " +
    Math.round(address['distance_to_whitehouse']) + " miles" +
    "</li>"
}

$("#addressSearch").on("submit", function(event) {
  event.preventDefault()
  let formData = objectifyForm($(this).serializeArray())
  getAddress(formData).then(function(addressData) {
    if (addressData['errors']) {
      window.alert(addressData['errors'])
    } else {
      $('#locationsList').append(addressListItem(addressData))
    }
  })
})
