import UIKit
import SnapKit

class CurrencyExchangeRateCell: UICollectionViewCell {
    static let reuseID = "CurrencyExchangeRateCell"
    
    private let currencyLabel = UILabel()
    private let rateLabel = UILabel()
    
    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        let starImage = UIImage(systemName: "star")
        button.setImage(starImage, for: .normal)
        button.tintColor = .systemGray
        return button
    }()
    
    private var displayedFavoriteState: Bool = false
    
    //callback when we tapped the button
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
        //update text
        currencyLabel.text = "\(model.baseCurrency) -> \(model.quoteCurrency)\n\(model.date)"
        rateLabel.text = String(format: "%.4f", model.quote)
        
        //save to uor temp var
        displayedFavoriteState = isFavorite
        
        //update button image with state
        let starName = displayedFavoriteState ? "star.fill" : "star"
        let starImage = UIImage(systemName: starName)
        favoriteButton.setImage(starImage, for: .normal)
        favoriteButton.tintColor = displayedFavoriteState ? .systemYellow : .systemGray
        
        favoriteButton.isHidden = !showFavoriteButton
    }
    
    private func setupViews() {
        currencyLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        currencyLabel.numberOfLines = 2
        
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
        //toggle local state
        displayedFavoriteState.toggle()
        
        //update image button
        let newImageName = displayedFavoriteState ? "star.fill" : "star"
        let newImage = UIImage(systemName: newImageName)
        favoriteButton.setImage(newImage, for: .normal)
        favoriteButton.tintColor = displayedFavoriteState ? .systemYellow : .systemGray
        
        onFavoriteTapped?()
    }
}
