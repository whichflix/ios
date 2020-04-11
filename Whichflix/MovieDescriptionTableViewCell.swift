import UIKit

class MovieDescriptionTableViewCell: UITableViewCell {
    init(description: String) {
        super.init(style: .default, reuseIdentifier: nil)

        let label = UILabel()
        label.numberOfLines = 0
        label.text = description

        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)

        let margin: CGFloat = 16
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -1 * margin).isActive = true
        label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1 * margin).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
