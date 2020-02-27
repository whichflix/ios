import UIKit
import Alamofire

class ElectionsViewController: UITableViewController {

    private lazy var session: Alamofire.Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.headers["X-Device-ID"] = UIDevice.current.identifierForVendor!.uuidString
        return Alamofire.Session(configuration: configuration)
    }()

    private var elections = [Election]() {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Events"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .done, target: self, action: #selector(promptForAnswer))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }

    private func refresh() {
        let url = "https://warm-wave-23838.herokuapp.com/v1/elections/"
        session.request(url).validate()
            .responseDecodable(of: Elections.self) { response in
                guard let elections = response.value else { return }
                self.elections = elections.all
        }
    }

    @objc private
    func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addTextField()


        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0]
            print(answer)
            // do something interesting with "answer" here
        }

        ac.addAction(submitAction)

        present(ac, animated: true)
    }
}
