import UIKit
import Alamofire

class ElectionViewController: UITableViewController {

    private let session: Alamofire.Session
    private var election: Election {
        didSet {
            title = election.title
        }
    }

    init(session: Alamofire.Session, election: Election) {
        self.session = session
        self.election = election
        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(userTappedEdit))
        let shareButton = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(userTappedShare))
        navigationItem.rightBarButtonItems = [shareButton, editButton]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }

    private func refresh() {
        title = election.title
    }

    @objc private func userTappedShare() {
        let url = URL(string: "whichflix://election?id=\(election.id)")!
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(activityViewController, animated: true)
    }

    @objc private func userTappedEdit() {
        let alertController = UIAlertController(title: "Rename movie night", message: nil, preferredStyle: .alert)
        alertController.addTextField()

        let textField = alertController.textFields![0]
        textField.text = election.title
        textField.placeholder = "Enter a movie night name"

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned alertController, self] _ in
            let movieNightName = alertController.textFields![0].text!
            if movieNightName.count > 0 {
                let url = "https://warm-wave-23838.herokuapp.com/v1/elections/\(self.election.id)/"
                let parameters = [
                    "title": "\(movieNightName)",
                ]
                self.session.request(url, method: .put, parameters: parameters)
                    .validate()
                    .responseDecodable(of: Election.self) { [weak self] response in
                        guard let election = response.value else { return }
                        self?.election = election
                        self?.refresh()
                }
            }
        }

        alertController.addAction(submitAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
}
