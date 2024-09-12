import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    var isDisabled: Bool

    var body: some View {
        TextField("Search", text: $searchText)
            .padding(7)
            .padding(.horizontal, 25)
            .background(isDisabled ? Color.gray.opacity(0.2) : Color.white)
            .cornerRadius(8)
            .padding(.horizontal, 10)
            .padding(.top, 10)
            .shadow(color: isDisabled ? Color.clear : Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
            .disabled(isDisabled)
    }
}
