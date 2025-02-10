
import Foundation
import Apollo
import SWOPAPI

final class GraphQLNetwork {
    
    private lazy var apolloClient: ApolloClient = {
        let baseURL = Configuration.baseURL
        let finalURLString = baseURL + "?api-key=" + Configuration.apiKey
        guard let url = URL(string: finalURLString) else {
            fatalError("Invalid baseUrl or apiKey")
        }
        return ApolloClient(url: url)
    }()
    //fetch latest currency rates like (EUR -> USD, CHF, HKD)

    func fetchLatestEuroRates(completion: @escaping (Result<[CurrencyRateModel], Error>) -> Void) {
        apolloClient.fetch(query: LatestEuroQuery()) { result in
            switch result {
            case .success(let graphQLResult):
                if let data = graphQLResult.data {
                    // data.latest is[LatestEuroQuery.Data.Latest]
                    let rates = data.latest.map { item -> CurrencyRateModel in

                        let dateString = String(describing: item.date)
                        let baseCurrency = item.baseCurrency
                        let quoteCurrency = item.quoteCurrency
                        let quoteString = String(describing: item.quote)
                        
                        let quoteValue = Double(quoteString) ?? 0.0
                        
                        return CurrencyRateModel(
                            date: dateString,
                            baseCurrency: baseCurrency,
                            quoteCurrency: quoteCurrency,
                            quote: quoteValue
                        )
                    }
                    completion(.success(rates))
                } else if let errors = graphQLResult.errors {
                    let message = errors.map { $0.localizedDescription }.joined(separator: ", ")
                    let error = NSError(domain: "", code: -1, userInfo: [
                        NSLocalizedDescriptionKey: message
                    ])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }


}
