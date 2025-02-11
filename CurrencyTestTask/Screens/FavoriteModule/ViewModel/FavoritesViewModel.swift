
import Foundation

final class FavoritesViewModel {
    
    private(set) var favorites = [CurrencyRateModel]()
    
    var onDataUpdated: (() -> Void)?
    
    init() {
        //subscribe for changes to our favorites
        NotificationCenter.default.addObserver(self, selector: #selector(favoritesDidChange), name: .favoritesDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
   //current list of favorite rates from FavoritesManager
    func loadFavorites() {
        favorites = FavoritesManager.shared.getAllFavorites()
        onDataUpdated?()
    }
    
    func removeFromFavorites(rate: CurrencyRateModel) {
        FavoritesManager.shared.toggleFavorite(rate)
        //loadFavorites() //reload list
    }
    
    func isFavorite(_ rate: CurrencyRateModel) -> Bool {
        return FavoritesManager.shared.isFavorite(rate)
    }
    
    @objc private func favoritesDidChange() {
        loadFavorites()
    }
}
