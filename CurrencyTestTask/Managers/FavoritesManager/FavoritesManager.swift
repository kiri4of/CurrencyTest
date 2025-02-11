import Foundation

extension Notification.Name {
    static let favoritesDidChange = Notification.Name("favoritesDidChange")
}

final class FavoritesManager {
    static let shared = FavoritesManager()
    private init() { }
    
    private var favoriteRates: [CurrencyRateModel] = []
    
    func isFavorite(_ rate: CurrencyRateModel) -> Bool {
        favoriteRates.contains(rate)
    }
    
    func toggleFavorite(_ rate: CurrencyRateModel) {
        if let index = favoriteRates.firstIndex(of: rate) {
            // Был в избранном — удаляем
            favoriteRates.remove(at: index)
        } else {
            // Не был — добавляем
            favoriteRates.append(rate)
        }
        
        // Шлём нотификацию, что список «Избранное» изменился
        NotificationCenter.default.post(name: .favoritesDidChange, object: nil)
    }
    
    func getAllFavorites() -> [CurrencyRateModel] {
        favoriteRates
    }
}
