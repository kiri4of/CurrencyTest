
import UIKit

class CurrencyViewController: BaseViewController<CurrencyView> {
    
    private var viewModel: CurrencyViewModel
    private var dataSource: UICollectionViewDiffableDataSource<Int, CurrencyRateModel>?
    
    init(mainView: CurrencyView, viewModel: CurrencyViewModel) {
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
    }
    
//MARK: - Private methods
    
    private func bind() {
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.applySnapshot()
            }
        }
        
        viewModel.onError = { [weak self] error in
            let ac = UIAlertController(title: "Error", message: "Error: \(error.localizedDescription)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            self?.present(ac, animated: true)
        }
        
        viewModel.fetchLatestEuroRates()
    }
    
    private func setupCollectionView() {
        mainView.collectionView.register(CurrencyCell.self, forCellWithReuseIdentifier: CurrencyCell.reuseID)
        mainView.collectionView.setCollectionViewLayout(createLayout(), animated: false)
    }
    
    private func createLayout() -> UICollectionViewLayout{
        let layout = UICollectionViewCompositionalLayout { (_, _) -> NSCollectionLayoutSection? in
            //item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            //group
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(adapted(dimensionSize: 60, to: dimension)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            //section
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
            section.interGroupSpacing = 8
            
            return section
        }
        return layout
    }
    
    //Int - section, ModelType - our Hashable element
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, CurrencyRateModel>(collectionView: mainView.collectionView) { (collectionView, indexPath, model) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrencyCell.reuseID, for: indexPath) as? CurrencyCell
            else { return UICollectionViewCell() }
            cell.configure(with: model)
            return cell
        }
    }
    
    private func applySnapshot() {
        guard let dataSource = dataSource else { return }
        var snapshot = NSDiffableDataSourceSnapshot<Int, CurrencyRateModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.rates, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func applyEmptySnapshot() {
        guard let dataSource = dataSource else { return }
        var snapshot = NSDiffableDataSourceSnapshot<Int, CurrencyRateModel>()
        snapshot.appendSections([0])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}

