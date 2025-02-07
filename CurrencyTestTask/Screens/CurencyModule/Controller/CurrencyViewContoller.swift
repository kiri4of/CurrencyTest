
import Foundation

class CurrencyViewController: BaseViewController<CurrencyView> {
    override init(mainView: CurrencyView) {
        super.init(mainView: mainView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .blue
    }
    
}
