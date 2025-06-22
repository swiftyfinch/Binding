import SaigaUI
import UIKit

final class ViewController: UIViewController {
    private let textField = TextField()
    private var text: String? {
        didSet {
            print("Text changed to \(text ?? "nil")")
        }
    }
    private let button = UIButton(type: .roundedRect)

    override func viewDidLoad() {
        super.viewDidLoad()
        addTextField()
        addButton()
    }

    private func addTextField() {
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            textField.widthAnchor.constraint(equalToConstant: 260),
        ])
        textField.configure(
            TextFieldConfiguration(
                textConfiguration: TextConfiguration(
                    text: "",
                    textColor: .darkText
                )
            )
        )
        textField.reconfigure {
            $0.textConfiguration.$text = Binding(
                get: { [weak self] in self?.text },
                set: { [weak self] in self?.text = $0 }
            )
        }
    }

    private func addButton() {
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
        ])
        button.setTitle("Hello World!", for: .normal)
        button.setTitleColor(.darkText, for: .normal)
        button.addTarget(self, action: #selector(setHelloWorld), for: .touchUpInside)
    }

    @objc
    private func setHelloWorld() {
        text = button.title(for: .normal)
        textField.reconfigure()
    }
}
