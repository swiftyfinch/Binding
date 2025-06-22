import UIKit

internal protocol Updatable {
    mutating func update()
}

public struct TextConfiguration: Equatable, Updatable {
    public static var empty: Self { TextConfiguration() }

    @Binding
    public var text: String?
    public var textColor: UIColor

    public init(text: String? = nil, textColor: UIColor = .clear) {
        self._text = .constant(text)
        self.textColor = textColor
    }

    public mutating func update() {
        $text.update()
    }
}

public struct TextFieldConfiguration: Equatable, Updatable {
    public static var empty: Self { TextFieldConfiguration() }

    public var backgroundColor: UIColor
    public var textConfiguration: TextConfiguration

    public init(
        backgroundColor: UIColor = .clear,
        textConfiguration: TextConfiguration = .empty
    ) {
        self.backgroundColor = backgroundColor
        self.textConfiguration = textConfiguration
    }

    mutating func update() {
        textConfiguration.update()
    }
}

public final class TextField: UIView {
    private let textField = UITextField()
    private(set) var configuration: TextFieldConfiguration = .empty

    public init() {
        super.init(frame: .zero)

        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        textField.borderStyle = .roundedRect
        textField.addTarget(
            self,
            action: #selector(textDidChange),
            for: .editingChanged
        )
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configure(_ configuration: TextFieldConfiguration) {
        guard self.configuration != configuration else { return }

        self.configuration = configuration
        applyConfiguration()
    }

    public func reconfigure(_ reconfigure: (inout TextFieldConfiguration) -> Void = { _ in }) {
        var newConfiguration = self.configuration
        reconfigure(&newConfiguration)
        newConfiguration.update()
        configure(newConfiguration)
    }

    private func applyConfiguration() {
        textField.backgroundColor = configuration.backgroundColor
        textField.text = configuration.textConfiguration.text
        textField.textColor = configuration.textConfiguration.textColor
    }

    @objc private func textDidChange() {
        reconfigure {
            $0.textConfiguration.text = textField.text
        }
    }
}
