import ballerina/http;

service /maps on new http:Listener(8080) {

    resource function get location(http:Caller caller, http:Request req) returns error? {
        // Extract the 'location' parameter from the request
        string? locationParam = req.getQueryParamValue("location");

        if locationParam is string {
            // Construct the path for the Google Maps Geocoding API
            string apiKey = "AIzaSyAtgPL-pqpo3G2tyjbzBqFcM3EYuT5H1rU"; // Replace with your API key
            string mapsApiPath = string `/maps/api/geocode/json?address=${locationParam}&key=${apiKey}`;

            // Create an HTTP client with base URL
            http:Client googleMapsClient = check new ("https://maps.googleapis.com");

            // Make the HTTP GET request with the constructed path
            http:Response mapsResponse = check googleMapsClient->get(mapsApiPath);

            // Parse the response as JSON
            json mapsData = check mapsResponse.getJsonPayload();

            // Send the JSON response back to the client (Flutter/Postman)
            check caller->respond(mapsData);
        } else {
            // If no location parameter, return an error message
            check caller->respond("Location parameter is missing");
        }
    }
}

//we are in the process of migrating the database from firebase to asgardeo
//We will implement a middelware with ballerina for aunthentication and handle the user data in the next version
//Also this would have our business logic and API calls to Google maps, weather api , news api which we are going to implement in the next version