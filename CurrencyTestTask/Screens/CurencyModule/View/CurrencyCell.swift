
import UIKit
import SnapKit

class CurrencyCell: UICollectionViewCell {
    static let reuseID = "CurrencyCell"
    
    private let currencyLabel = UILabel()
    private let rateLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: CurrencyRateModel) {
        currencyLabel.text = "\(model.baseCurrency) -> \(model.quoteCurrency)\n\(model.date)"
        rateLabel.text = String(format: "%.4f", model.quote)
    }
        
    private func setupViews() {
           currencyLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
           currencyLabel.numberOfLines = 2 // two lines for data and currency
           
           rateLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
           rateLabel.textAlignment = .right
           
           contentView.addSubview(currencyLabel)
           contentView.addSubview(rateLabel)
           
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
               make.trailing.equalToSuperview().inset(8)
               make.centerY.equalToSuperview()
           }
       }
    
}

