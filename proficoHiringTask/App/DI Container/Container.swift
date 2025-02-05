//
//  Container.swift
//  proficoHiringTask
//
//  Created by Emir Vajzović on 3. 2. 2025..
//


class Container {
    static let shared = Container()
    private var services: [String: Any] = [:]
    private init() {}
    
    func register<Service, Implementation>(_ service: Implementation, as type: Service.Type) {
        let key = String(describing: type)
        services[key] = service
    }
    
    func resolve<Service>(_ type: Service.Type) -> Service {
        let key = String(describing: type)
        guard let service = services[key] as? Service else {
            fatalError("Dependency \(key) not registered.")
        }
        return service
    }
}

@propertyWrapper struct Injected<T> {
    var wrappedValue: T
    
    init() {
        self.wrappedValue = Container.shared.resolve(T.self)
    }
}
