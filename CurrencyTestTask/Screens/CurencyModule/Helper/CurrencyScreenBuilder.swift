
import Foundation

class MainScreenBuilder {
    public static func createCurrencyViewController() -> CurrencyViewController{
        let view = CurrencyView()
        let network = GraphQLNetwork()
        let viewModel = CurrencyViewModel(network: network)
        let vc = CurrencyViewController(mainView: view, viewModel: viewModel)
        return vc
    }
}
