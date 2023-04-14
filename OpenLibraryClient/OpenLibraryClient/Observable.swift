import Foundation


class Observable<T> {
    
    typealias Listener = (T) -> Void
    
    var value: T {
        didSet {
            for listener in self.listeners {
                listener(self.value)
            }
        }
    }
    
    private(set) var listeners: [Listener] = []
    
    init(value: T) {
        self.value = value
    }
    
    func bind(_ listener: @escaping Listener) {
        self.listeners.append(listener)
        listener(self.value)
    }
    
}
