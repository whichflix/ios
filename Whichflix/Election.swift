import Foundation

struct Election: Codable, Identifiable {
    let id: String
    let title: String
    let candidates: [Candidate]
    let participants: [Participant]

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case candidates
        case participants
    }
}

struct Elections: Codable {
    let all: [Election]

    enum CodingKeys: String, CodingKey {
      case all = "results"
    }
}
