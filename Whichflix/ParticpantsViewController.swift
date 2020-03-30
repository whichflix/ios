import UIKit

class PartipantsViewController: UITableViewController {
    private var participants: [Participant] {
        didSet {
            tableView.reloadData()
        }
    }

    init(participants: [Participant]) {
        self.participants = participants
        super.init(style: .plain)
        title = "Participants"
        let dismissButton = UIBarButtonItem(title: "Dismiss", style: .plain, target: self, action: #selector(userTappedDismiss))
        navigationItem.leftBarButtonItem = dismissButton
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: UITableViewControllerDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return participants.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = participants[indexPath.row].name
        return cell
    }

    @objc private func userTappedDismiss() {
        dismiss(animated: true, completion: nil)
    }
}
