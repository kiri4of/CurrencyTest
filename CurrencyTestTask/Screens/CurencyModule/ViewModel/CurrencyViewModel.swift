
import Foundation

final class CurrencyViewModel {
    private(set) var rates = [CurrencyRateModel]()
    
    private let network: GraphQLNetwork
    
    init(network: GraphQLNetwork) {
        self.network = network
    }
    //when the rates were updated
    var onDataUpdated: (() -> Void)?
    
    // when we got an error
    var onError: ((Error) -> Void)?
    
    func fetchLatestEuroRates() {
        network.fetchLatestEuroRates { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let fetchedRates):
                self.rates = fetchedRates
                self.onDataUpdated?()
            case .failure(let error):
                self.onError?(error)
            }
        }
    }
    
    func toggleFavorite(for rate: CurrencyRateModel) {
        FavoritesManager.shared.toggleFavorite(rate)
        self.onDataUpdated?()
    }
    
    func isFavoirite(_ rate: CurrencyRateModel) -> Bool {
        return FavoritesManager.shared.isFavorite(rate)
    }
}
