import UIKit
import AlamofireImage


class MovieDetailsHeaderView: UIView {
    private let movie: Movie

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .yellow
        imageView.clipsToBounds = true
        return imageView
    }()

    init(movie: Movie) {
        self.movie = movie
        super.init(frame: .zero)
        backgroundColor = .red

        if let imageURL = URL(string: movie.imageURL) {
            imageView.af.setImage(withURL: imageURL)
        }

        addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        NSLayoutConstraint(item: imageView,
                           attribute: .width,
                           relatedBy: .equal,
                           toItem: imageView,
                           attribute: .height,
                           multiplier: (2/3),
                           constant: 0).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
