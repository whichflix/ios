import Foundation

struct Candidate: Codable {
    let id: String
    let voteCount: UInt
    let votingParticipants: [Participant]
    let movie: Movie

    enum CodingKeys: String, CodingKey {
        case id
        case voteCount = "vote_count"
        case votingParticipants = "voting_participants"
        case movie
    }
}
