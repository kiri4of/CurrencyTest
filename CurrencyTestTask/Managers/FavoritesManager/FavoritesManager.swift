import Foundation

extension Notification.Name {
    static let favoritesDidChange = Notification.Name("favoritesDidChange")
}

final class FavoritesManager {
    static let shared = FavoritesManager()
    private init() {
           loadFromStorage()
       }
    
    private var favoriteRates: [CurrencyRateModel] = []
    private let favoritesKey = "favoriteRatesKey"
    
    func isFavorite(_ rate: CurrencyRateModel) -> Bool {
        favoriteRates.contains(rate)
    }
    
    func toggleFavorite(_ rate: CurrencyRateModel) {
           if let index = favoriteRates.firstIndex(of: rate) {
              //if was in favorites => delete
               favoriteRates.remove(at: index)
           } else {
               favoriteRates.append(rate)
           }
           
           saveToStorage()
           
           //notify all those who have subscribe that favourites have changed
           NotificationCenter.default.post(name: .favoritesDidChange, object: nil)
       }
    
    func getAllFavorites() -> [CurrencyRateModel] {
        favoriteRates
    }
    //actually better to create UserDefault Manager... 
    private func saveToStorage() {
          do {
              let data = try JSONEncoder().encode(favoriteRates)
              UserDefaults.standard.set(data, forKey: favoritesKey)
          } catch {
              print("Error by code rates:", error.localizedDescription)
          }
      }
      
      private func loadFromStorage() {
          guard let data = UserDefaults.standard.data(forKey: favoritesKey) else { return }
          do {
              let savedRates = try JSONDecoder().decode([CurrencyRateModel].self, from: data)
              self.favoriteRates = savedRates
          } catch {
              print("Error by decode rates:", error.localizedDescription)
          }
      }
    
}
