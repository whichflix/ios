import Foundation

struct Election: Codable, Identifiable {
    let id: String
    let title: String
    let candidates: [Candidate]

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case candidates
    }
}
