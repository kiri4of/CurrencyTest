import UIKit

class CurrencyViewController: BaseViewController<CurrencyView> {
    
    private var viewModel: CurrencyViewModel
    private var adapter: CollectionAdapter!
    
    init(mainView: CurrencyView, viewModel: CurrencyViewModel) {
        self.viewModel = viewModel
        super.init(mainView: mainView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //init the adapter with the collectionView
        adapter = CollectionAdapter(collectionView: mainView.collectionView)
        adapter.applyEmptySnapshot()
        
        //callbacks
        adapter.isFavorite = { [weak self] rate in
            return self?.viewModel.isFavoirite(rate) ?? false
        }
        
        adapter.onFavoriteTapped = { [weak self] rate in
            self?.viewModel.toggleFavorite(for: rate)
        }
       //bind the viewModel update callbacks
        bind()
        //make request
        viewModel.fetchLatestEuroRates()
    }
    
    private func bind() {
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.adapter.items = self?.viewModel.rates ?? []
            }
        }
        
        viewModel.onError = { [weak self] error in
            let ac = UIAlertController(
                title: "Error",
                message: error.localizedDescription,
                preferredStyle: .alert
            )
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            self?.present(ac, animated: true)
        }
    }
}
