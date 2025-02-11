
import UIKit
import SnapKit

class CurrencyExchangeRateCell: UICollectionViewCell {
    static let reuseID = "CurrencyExchangeRateCell"
    
    private let currencyLabel = UILabel()
    private let rateLabel = UILabel()
    
    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        let starImage = AppImages.starImage
        button.setImage(starImage, for: .normal)
        return button
    }()
    
    private var isFavorite = false
    
    var onFavoriteTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
        
        favoriteButton.addTarget(self, action: #selector(didTapFavoriteButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    } 
    
    func configure(with model: CurrencyRateModel, isFavorite: Bool, showFavoriteButton: Bool) {
        currencyLabel.text = "\(model.baseCurrency) -> \(model.quoteCurrency)\n\(model.date)"
        rateLabel.text = String(format: "%.4f", model.quote)
        
        let starName = isFavorite ? "star.fill" : "star"
        let starImage = UIImage(systemName: starName)
        favoriteButton.setImage(starImage, for: .normal)
        favoriteButton.isHidden = !showFavoriteButton 
    }
    
    private func setupViews() {
        currencyLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        currencyLabel.numberOfLines = 2 // two lines for data and currency
        
        rateLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        rateLabel.textAlignment = .right
        
        contentView.addSubview(currencyLabel)
        contentView.addSubview(rateLabel)
        contentView.addSubview(favoriteButton)
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
    }
    
    private func setupConstraints() {
        currencyLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
        }
        
        rateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(50)
            make.centerY.equalToSuperview()
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(adapted(dimensionSize: 30, to: dimension))
        }
    }
    
    @objc private func didTapFavoriteButton() {
        isFavorite.toggle()
        
        let newImage = isFavorite ? AppImages.favoriteImage : AppImages.starImage
        favoriteButton.setImage(newImage, for: .normal)
        
        onFavoriteTapped?()
    }
}

