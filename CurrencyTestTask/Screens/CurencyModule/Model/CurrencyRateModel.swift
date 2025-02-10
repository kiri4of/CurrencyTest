
import Foundation

struct CurrencyRateModel: Hashable {
    let date: String
    let baseCurrency: String
    let quoteCurrency: String
    let quote: Double
}

