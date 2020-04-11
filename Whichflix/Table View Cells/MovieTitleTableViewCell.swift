import UIKit

class MovieTitleTableViewCell: UITableViewCell {
    init(title: String) {
        super.init(style: .default, reuseIdentifier: nil)
        textLabel?.text = title
        textLabel?.font = UIFont.boldSystemFont(ofSize: 24)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
