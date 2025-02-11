import UIKit

class FavoritesViewController: BaseViewController<FavoritesView> {
    
    private let viewModel: FavoritesViewModel
    private var adapter: CollectionAdapter!
    
    init(mainView: FavoritesView, viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
        super.init(mainView: mainView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adapter = CollectionAdapter(collectionView: mainView.collectionView)
        
        adapter.applyEmptySnapshot()
        
        adapter.showFavoriteButton = false
        
        adapter.isFavorite = { _ in true }
        
        bind()
        viewModel.loadFavorites()
    }
    
    private func bind() {
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.adapter.items = self?.viewModel.favorites ?? []
            }
        }
    }
}
