import UIKit

class CandidateTableViewCell: UITableViewCell {

    var candidate: Candidate {
        didSet {
            refreshSubviews()
        }
    }

    weak var delegate: CandidateVoteToggleAttemptDelegate?

    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        return titleLabel
    }()

    lazy var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blue.cgColor
        button.addTarget(self, action: #selector(userTappedButton), for: .touchUpInside)
        return button
    }()

    init(candidate: Candidate) {
        self.candidate = candidate
        super.init(style: .default, reuseIdentifier: nil)
        contentView.addSubview(movieImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(button)

        refreshSubviews()

        let margin: CGFloat = 16
        movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin).isActive = true
        movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin).isActive = true
        movieImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        movieImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true

        titleLabel.centerYAnchor.constraint(equalTo: movieImageView.centerYAnchor).isActive=true
        titleLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: margin).isActive = true
        titleLabel.trailingAnchor.constraint(equalToSystemSpacingAfter: contentView.trailingAnchor, multiplier: 1.0).isActive = true

        button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin).isActive = true
        button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -1 * margin).isActive = true
        button.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: margin).isActive = true
        button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1 * margin).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func refreshSubviews() {
        titleLabel.text = candidate.movie.title

        let buttonTitle = candidate.voteCount > 0 ? "\(candidate.voteCount) 👍" : "👍"
        button.setTitle(buttonTitle, for: .normal)
        button.backgroundColor = candidate.containsMyVote ? .blue : .white

        movieImageView.af.setImage(withURL: URL(string: candidate.movie.imageURL)!, placeholderImage: UIImage(named: "placeholder-movie.jpg"))
    }

    @objc private func userTappedButton() {
        delegate?.userAttemptedToToggleVote(candidate: candidate)
    }
}
