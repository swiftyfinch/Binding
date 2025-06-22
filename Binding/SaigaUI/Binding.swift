@propertyWrapper
public struct Binding<T: Equatable>: Equatable {
    private let get: Box<() -> T>
    private let set: Box<(T) -> Void>
    private var storage: T

    public var wrappedValue: T {
        get { storage }
        set {
            storage = newValue
            set.wrappedValue(newValue)
        }
    }

    public var projectedValue: Binding<T> {
        get { self }
        set { self = newValue }
    }

    public init(
        get: @escaping () -> T,
        set: @escaping (T) -> Void
    ) {
        self.get = Box(get)
        self.set = Box(set)
        self.storage = get()
    }

    public mutating func update() {
        storage = get.wrappedValue()
    }

    public static func constant(_ constant: T) -> Self {
        Binding(get: { constant }, set: { _ in })
    }
}

import UIKit

struct Box<T>: Equatable {
    private let id: UUID
    let wrappedValue: T

    init(_ wrappedValue: T) {
        self.id = UUID()
        self.wrappedValue = wrappedValue
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
