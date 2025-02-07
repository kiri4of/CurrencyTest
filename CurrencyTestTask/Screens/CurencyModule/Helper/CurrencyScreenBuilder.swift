
import Foundation

class MainScreenBuilder {
    public static func createCurrencyViewController() -> CurrencyViewController{
        let view = CurrencyView()
        let vc = CurrencyViewController(mainView: view)
        return vc
    }
}
