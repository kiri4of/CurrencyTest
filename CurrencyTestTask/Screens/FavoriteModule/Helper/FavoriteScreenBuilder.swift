
import Foundation

class FavoriteScreenBuilder {
    public static func createFavoriteViewController() -> FavoriteViewController{
        let view = FavoriteView()
        let vc = FavoriteViewController(mainView: view)
        return vc
    }
}
