import SwiftUI

struct ContentView: View {
    @State private var searchText = ""
    @State private var searchResults: [Place] = []
    @State private var selectedCategory: String? = nil

    var body: some View {
        VStack {
            // Call SearchBar from separate file
            SearchBar(searchText: $searchText, isDisabled: selectedCategory != nil)
            
            FilterThumbnailView(selectedCategory: $selectedCategory, searchText: $searchText)
                            .padding(.vertical)
            
            SearchResultsView(searchResults: searchResults, selectedCategory: selectedCategory)
            
            Spacer() // Push everything to the top
            
            // Call SearchButton from separate file
            SearchButton(query: searchText, searchResults: $searchResults, selectedCategory: selectedCategory)
            

        }
    }
}

#Preview {
    ContentView()
}
