import Foundation

struct PlaceResponse: Codable {
    let places: [Place]
}

struct Place: Codable {
    let types: [String]
    let formattedAddress: String
    let priceLevel: String?
    let displayName: DisplayName
    let photos: [PhotoReference]?
}

struct DisplayName: Codable {
    let text: String
}

struct PhotoReference: Codable {
    let name: String
    let widthPx: Int
    let heightPx: Int
    let authorAttributions: [AuthorAttribution]
}

struct AuthorAttribution: Codable {
    let displayName: String
    let uri: String
    let photoUri: String
}
