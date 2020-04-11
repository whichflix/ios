import UIKit
import AlamofireImage


class MovieDetailsHeaderView: UIView {
    private let movie: Movie

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
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
        let margin: CGFloat = 0
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: margin).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: margin).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -1 * margin).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1 * margin).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
