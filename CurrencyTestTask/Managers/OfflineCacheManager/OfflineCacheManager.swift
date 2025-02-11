
import Foundation

//manager for cache and offline mode
final class OfflineCacheManager {
    
    static let shared = OfflineCacheManager()
    private init() {}
    
    private let cacheKey = "CachedCurrencyRates"
    
    //save in userDefault in JSON format
    func saveRates(_ rates: [CurrencyRateModel]) {
        do {
            let data = try JSONEncoder().encode(rates)
            UserDefaults.standard.set(data, forKey: cacheKey)
        } catch {
            print("Error by encode rates: ", error)
        }
    }
    
    //load previously saved courses ff nothing => empty array
    func loadRates() -> [CurrencyRateModel] {
        guard let data = UserDefaults.standard.data(forKey: cacheKey) else { return [] }
        do {
            let rates = try JSONDecoder().decode([CurrencyRateModel].self, from: data)
            return rates
        } catch {
            print("Error by decode rates:", error)
            return []
        }
    }
    
    //delete cache if needed
    func clearCache() {
        UserDefaults.standard.removeObject(forKey: cacheKey)
    }
}
