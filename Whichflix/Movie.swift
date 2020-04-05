struct Movie: Codable, Identifiable {
    let id: String
    let title: String
    let imageURL: String
    let description: String
    let releaseYear: String
    let genres: [String]

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case imageURL = "image_url"
        case description
        case releaseYear = "release_year"
        case genres
    }
}

struct Movies: Codable {
    let all: [Movie]

    enum CodingKeys: String, CodingKey {
      case all = "results"
    }
}
