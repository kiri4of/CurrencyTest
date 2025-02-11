
import Foundation

class FavoritesScreenBuilder {
    public static func createFavoritesViewController() -> FavoritesViewController{
        let view = FavoritesView()
        let viewModel = FavoritesViewModel()
        let vc = FavoritesViewController(mainView: view, viewModel: viewModel)
        return vc
    }
}

