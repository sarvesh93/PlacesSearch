import SwiftUI

struct SearchResultsView: View {
    let searchResults: [Place] // Pass the search results into the view
    let selectedCategory: String?

    var body: some View {
        ScrollView {
            if searchResults.isEmpty {
                Text("No results")
                    .foregroundColor(.gray)
                    .padding(.top, 20)
            } else {
                // Loop through the results and display them in the ScrollView
                ForEach(searchResults, id: \.formattedAddress) { place in
                    
                    let matchingPhotoUri = getMatchingPhotoUri(for: place)
                    
                    VStack(alignment: .center) {
                        
                        Text(place.displayName.text.trimmingCharacters(in: .whitespacesAndNewlines))
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 2)
                                                 
                                               // AsyncImage with loading spinner
                        
                        if !matchingPhotoUri.isEmpty {
                            AsyncImage(url: URL(string: matchingPhotoUri)) { phase in
                                switch phase {
                                case .empty:
                                    // Show the loading spinner while the image is being loaded
                                    ZStack {
                                        Color.clear // Background for image space
                                        ProgressView() // Loading spinner
                                            .progressViewStyle(CircularProgressViewStyle())
                                            .scaleEffect(1.5)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 200)// Adjust width and height for better alignment
                                    
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 200)
                                        .cornerRadius(8)
                                        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                                    
                                case .failure:
                                    // If there's a failure, show a placeholder image
                                    Image(systemName: "photo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 200)
                                    
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .padding(.vertical, 10)
                        }else{
                            // Display placeholder image when matchingPhotoUri is empty (no AsyncImage needed)
                                                        Image(systemName: "photo")
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                            .frame(height: 200)
                                                            .foregroundColor(.gray)
                                                            .padding(.vertical, 10)
                        }
                        
                        Text(place.formattedAddress.trimmingCharacters(in: .whitespacesAndNewlines))
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .fixedSize(horizontal: false, vertical: true)
                        if let priceLevel = place.priceLevel {
                            Text(priceLevel.trimmingCharacters(in: .whitespacesAndNewlines))
                                .font(.footnote)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    .padding()
                    .frame(width: UIScreen.main.bounds.width * 0.85)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                }
            }
        }
    }
    
    
        func getMatchingPhotoUri(for place: Place) -> String {
            return place.photos?
                .first(where: { photo in
                    photo.authorAttributions.contains { $0.displayName.range(of: place.displayName.text) != nil }
                })?
                .authorAttributions.first?.photoUri ?? ""
        }
    
}
