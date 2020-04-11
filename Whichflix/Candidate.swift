import Foundation

struct Candidate: Codable {
    let id: String
    var voteCount: UInt
    var votingParticipants: [Participant]
    let movie: Movie

    enum CodingKeys: String, CodingKey {
        case id
        case voteCount = "vote_count"
        case votingParticipants = "voting_participants"
        case movie
    }
}

extension Candidate {
    var containsMyVote: Bool {
        return votingParticipants.map { $0.id }.contains(AppDelegate.UserID)
    }

    mutating func addMe() {
        voteCount += 1
        votingParticipants.append(Participant.me)
    }

    mutating func removeMe() {
        guard let index = votingParticipants.map({ $0.id }).firstIndex(of: AppDelegate.UserID) else { return }
        voteCount -= 1
        votingParticipants.remove(at: index)
    }
}


private extension Participant {
    static var me: Participant {
        return Participant(id: AppDelegate.UserID, name: UserNameStore.shared.name)
    }
}
