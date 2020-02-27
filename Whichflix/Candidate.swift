import Foundation

struct Candidate: Codable {
    let id: String
    let voteCount: UInt
    let votingParticipants: [Participant]
}
