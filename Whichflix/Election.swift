import Foundation

struct Election: Codable, Identifiable {
    let id: String
    let title: String
    let candidate: [Candidate]
}
