import UIKit

final class CollectionAdapter: NSObject {
    
    private let collectionView: UICollectionView
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, CurrencyRateModel>!
    var items: [CurrencyRateModel] = [] {
        didSet {
            applySnapshot() //also for reload
        }
    }
    var showFavoriteButton = true
    
    var onFavoriteTapped: ((CurrencyRateModel) -> Void)?
    var isFavorite: ((CurrencyRateModel) -> Bool)?
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        setupCollectionView()
        configureDataSource()
    }
    
    private func setupCollectionView() {
        collectionView.register(CurrencyExchangeRateCell.self,forCellWithReuseIdentifier: CurrencyExchangeRateCell.reuseID)
        collectionView.delegate = self
        collectionView.setCollectionViewLayout(createLayout(), animated: false)
    }
    
   //CompositionLayout
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (_, _) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(adapted(dimensionSize: 60, to: dimension))
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
            section.interGroupSpacing = 8
            
            return section
        }
        return layout
    }
    
    //configure dataSource
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, CurrencyRateModel>(
            collectionView: collectionView
        ) { [weak self] (collectionView, indexPath, rate) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CurrencyExchangeRateCell.reuseID,
                for: indexPath
            ) as? CurrencyExchangeRateCell else {
                return UICollectionViewCell()
            }
            guard let self = self else { return cell }
            
            //is this element in favorites list?
            let isFav = self.isFavorite?(rate) ?? false
            
            cell.configure(
                with: rate,
                isFavorite: isFav,
                showFavoriteButton: self.showFavoriteButton
            )
            
            //callback for favorite button is tapped
            cell.onFavoriteTapped = { [weak self] in
                self?.onFavoriteTapped?(rate)
                
            }
            
            return cell
        }
    }
    //applies an empty snapshot to make collectionView clear
    func applyEmptySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CurrencyRateModel>()
        snapshot.appendSections([0])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
  
   //applies a snapshot to update the collectionView with current items
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CurrencyRateModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(items, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension CollectionAdapter: UICollectionViewDelegate {
    
}
