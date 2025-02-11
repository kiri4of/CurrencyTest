
import Foundation

struct CurrencyRateModel: Hashable, Codable {
    let date: String
    let baseCurrency: String
    let quoteCurrency: String
    let quote: Double
}

