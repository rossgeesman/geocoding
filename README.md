# Excercise Overview

## Setup
You can setup and run this app as described in the original repo. 

Here are the main features:

## Address Class
I took some clues from the existing Address spec tests and implemented the class. An addresss can be instantiated with either geographic coordinates (lat, lng) or with a street address string. Calling `#geocode!` on the address uses the Geocoder gem to lookup and add missing data to the Address object's internal state. None of this data is persisted server-side but it seems that the Geocoder gem provides some nice integration points for ActiveRecord so it would be easy to do so.

The `#geocode!` method handles errors that might be raised by the Geocoder gem however the gem is inconsistent and sometimes simply prints the errors. I chose to raise errors within the `#geocode!` method if this happens but I suppose that is debatable.

## Frontend/UI
I chose to make requests to the server asynchronously with JS. When a response is received, the address data is appended to the list of addresses. Errors are just alerted through the browser. If I had more time, I would have implemented nicer error display using Bootstrap modals or flash messages. Also, the UI is a little ugly and I think it would have been nice to make the "distance to Whitehouse" calculation be optional, instead of using a single API request.

## Sinatra
I've never used Sinatra before but I had fun playing with it. I kept things pretty minimal and only added a single `/address` route for the client to talk to. Also, since I wrote a bit of JS and got annoyed purging my browser cache, I added versioning so cached scripts will be expired regularly.

I didn't sort the address list because I was short for time this week. If I did implement this in the existing code, I would probably maintain a sorted array of the distance-to-whitehouse numbers on the client and then append the new addresses onto the list in the proper position.


