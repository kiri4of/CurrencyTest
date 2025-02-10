
import Foundation

struct Configuration {
    static let baseURL: String = {
        return value(forKey: "baseURL") as? String ?? ""
    }()
    
    static let apiKey: String = {
        return value(forKey: "apiKey") as? String ?? ""
    }()
    
    private static func value(forKey key: String) -> Any? {
        guard let path = Bundle.main.path(forResource: "Configuration", ofType: "plist"), let dict = NSDictionary(contentsOfFile: path) else {
            fatalError("Configuration.plist now foun or not valid")
        }
        return dict[key]
    }
}
