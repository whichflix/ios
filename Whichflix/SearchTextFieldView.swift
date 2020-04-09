import UIKit

protocol SearchTextFieldViewDelegate: class {
    func searchTextFieldView(searchTextFieldView: SearchTextFieldView, didChangeText text: String)
    func searchTextFieldViewWillClearText(searchTextFieldView: SearchTextFieldView)
}

final class SearchTextFieldView: UIView {

    // MARK: - Properties

    weak var delegate: SearchTextFieldViewDelegate?

    var text: String? {
        get {
            return textField.text
        }

        set {
            textField.text = newValue
        }
    }

    var placeholder: String? {
        get {
            return textField.placeholder
        }

        set {
            textField.placeholder = newValue
        }
    }

    private let textField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.clearButtonMode = .whileEditing
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        return textField
    }()


    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(textField)
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[textField]-|", options: [], metrics: nil, views: ["textField":textField])
            + [NSLayoutConstraint(item: textField, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0)]
        NSLayoutConstraint.activate(constraints)

        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

        backgroundColor = .green
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    @objc private func textFieldDidChange() {
        delegate?.searchTextFieldView(searchTextFieldView: self, didChangeText: textField.text ?? "")
    }

}

extension SearchTextFieldView: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        delegate?.searchTextFieldViewWillClearText(searchTextFieldView: self)
        return true
    }
}


extension SearchTextFieldView {


    // MARK: - UIResponder

    override var canBecomeFirstResponder: Bool {
        return textField.canBecomeFirstResponder
    }

    override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }

    override var canResignFirstResponder: Bool {
        return textField.canResignFirstResponder
    }

    override func resignFirstResponder() -> Bool {
        return textField.resignFirstResponder()
    }

    override var isFirstResponder: Bool {
        return textField.isFirstResponder
    }
}
