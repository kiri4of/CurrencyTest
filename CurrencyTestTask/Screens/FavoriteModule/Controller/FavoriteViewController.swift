import UIKit

class FavoritesViewController: BaseViewController<FavoritesView> {
    
    private let viewModel: FavoritesViewModel
    private var dataSource: UICollectionViewDiffableDataSource<Int, CurrencyRateModel>?
    
    init(mainView: FavoritesView, viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
        super.init(mainView: mainView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        configureDataSource()
        applyEmptySnapshot()
        
        bind()
        //load Favorites
        viewModel.loadFavorites()
    }
    
    private func bind() {
        viewModel.onDataUpdated = { [weak self] in
            self?.applySnapshot()
        }
    }
    
    private func setupCollectionView() {
        mainView.collectionView.register(CurrencyExchangeRateCell.self,
                                         forCellWithReuseIdentifier: CurrencyExchangeRateCell.reuseID)
        mainView.collectionView.setCollectionViewLayout(createLayout(), animated: false)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (_, _) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(adapted(dimensionSize: 60, to: dimension)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
            section.interGroupSpacing = 8
            return section
        }
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, CurrencyRateModel>(
            collectionView: mainView.collectionView)
        { [weak self] (collectionView, indexPath, rate) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CurrencyExchangeRateCell.reuseID,
                for: indexPath
            ) as? CurrencyExchangeRateCell else {
                return UICollectionViewCell()
            }
            
            guard let self = self else { return cell }
            
            let isFav = self.viewModel.isFavorite(rate)
            cell.configure(with: rate, isFavorite: isFav, showFavoriteButton: false )
            
            cell.onFavoriteTapped = { [weak self] in
                self?.viewModel.removeFromFavorites(rate: rate)
            }
            return cell
        }
    }
    
    private func applyEmptySnapshot() {
        guard let dataSource = dataSource else { return }
        var snapshot = NSDiffableDataSourceSnapshot<Int, CurrencyRateModel>()
        snapshot.appendSections([0])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func applySnapshot() {
        guard let dataSource = dataSource else { return }
        var snapshot = NSDiffableDataSourceSnapshot<Int, CurrencyRateModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.favorites, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
