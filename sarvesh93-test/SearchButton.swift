import SwiftUI

struct SearchButton: View {
    var query: String
    @Binding var searchResults: [Place]
    let selectedCategory: String?

    var body: some View {
        Button(action: {
            performSearch(query: query)
        }) {
            Text("Search")
                .frame(width: UIScreen.main.bounds.width * 0.4) // Set width to 40% of screen width
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
          
        }
    }
    
    // Perform an HTTP POST request with the query
        func performSearch(query: String) {
            if query.isEmpty && selectedCategory == nil {
                print("Both query and selectedCategory are empty. No search performed.")
                return
            }
            
            searchResults = []

            // The API endpoint
            guard let url = URL(string: "https://places.googleapis.com/v1/places:searchText") else {
                print("Invalid URL.")
                return
            }
            
            let textQuery = query.isEmpty ? selectedCategory ?? "" : query

            // Prepare the POST request body as JSON
            let parameters: [String: Any] = [
                "textQuery": textQuery
            ]
            
            // Convert parameters to JSON data
            guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
                print("Error serializing JSON data.")
                return
            }

            // Create the POST request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            // Set headers
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("AIzaSyCMHXTXOrB1MTDLvnz7g7b4qIxDaOb4TbE", forHTTPHeaderField: "X-Goog-Api-Key") // Replace 'API_KEY' with your actual key
            request.setValue("places.displayName,places.formattedAddress,places.priceLevel,places.photos,places.types", forHTTPHeaderField: "X-Goog-FieldMask")
            
            // Attach JSON data to the request
            request.httpBody = jsonData

            // Create the data task for sending the request
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error during HTTP request: \(error.localizedDescription)")
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print("Server error or invalid response.")
                    return
                }

                // Check the response data
                if let data = data {
                                do {
                                    // Decode the response using the PlaceResponse model
                                    let placeResponse = try JSONDecoder().decode(PlaceResponse.self, from: data)
                                    
                                    DispatchQueue.main.async {
                                        // Update the searchResults array with parsed data
                                        searchResults = placeResponse.places
                                    }
                                } catch let decodingError {
                                    print("Error decoding JSON response: \(decodingError)")
                                }
                            }
            }
            
            task.resume()
        }
}
