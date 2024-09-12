import SwiftUI

struct FilterThumbnailView: View {
    let categories = [
            ("Restaurants", "fork.knife"),
            ("Museums", "paintbrush"),
            ("Parks", "leaf"),
            ("Hotels", "bed.double"),
            ("Shopping", "cart")
        ] // Your categories with corresponding SF Symbol icons
    @Binding var selectedCategory: String? // Single selected category
    @Binding var searchText: String 
    
    var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(categories, id: \.0) { category, iconName in
                        FilterThumbnail(category: category, isSelected: selectedCategory == category, iconName: iconName)
                            .onTapGesture {
                                toggleCategorySelection(category: category) // Handle selection/deselection
                                searchText = ""
                            }
                    }
                }
                .padding(.horizontal)
            }
        }
        
        private func toggleCategorySelection(category: String) {
            if selectedCategory == category {
                selectedCategory = nil // Deselect if it's already selected
            } else {
                selectedCategory = category // Select the tapped category
            }
        }
    
}

struct FilterThumbnail: View {
    let category: String
    let isSelected: Bool
    let iconName: String // The name of the SF Symbol icon
    
    var body: some View {
        VStack {
            // Square container with rounded corners
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white) // Background color of the thumbnail
                .frame(width: 60, height: 60)
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                .overlay(
                    Image(systemName: iconName) // SF Symbol icon
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundColor(isSelected ? .blue : .gray)
                )
               
            
            // Category Text
            Text(category)
                .font(.caption)
                .foregroundColor(isSelected ? Color.blue : Color.gray)
        }
    }
}

