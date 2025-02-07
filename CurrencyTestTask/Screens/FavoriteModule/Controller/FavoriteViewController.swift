
import Foundation

class FavoriteViewController: BaseViewController<FavoriteView> {
    override init(mainView: FavoriteView) {
        super.init(mainView: mainView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .yellow
    }
    
}
