protocol ElectionChangeDelegate: class {
    func electionChangeDidUpdateElection(election: Election)
    func electionChangeDidLeaveElection(election: Election)
}
