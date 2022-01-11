import UIKit
import Kingfisher
import SnapKit

final class NewsTableViewCell: UITableViewCell {
    let urlImageView = UIImageView()
    let titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        urlImageView.image = nil
    }
}

// MARK: - Public methods
extension NewsTableViewCell {
    func setModel(_ model: News) {
        let url = URL(string: model.urlToImage)!
        urlImageView.kf.setImage(with: url)
        
        let text: String
        
        if let author = model.author {
            text = "\(model.title) - \(author)"
        } else {
            text = "\(model.title)"
        }
        
        titleLabel.text = .some(text)
    }
}

// MARK: - Private methods
private extension NewsTableViewCell {
    private func setup() {
        urlImageView.contentMode = .scaleAspectFill
        urlImageView.layer.cornerRadius = 4
        urlImageView.layer.masksToBounds = true
        self.contentView.addSubview(urlImageView)
        
        titleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .darkGray
        self.contentView.addSubview(titleLabel)
        
        setupLayout()
    }
    
    private func setupLayout() {
        urlImageView.snp.makeConstraints {
            $0.width.equalTo(50)
            $0.height.equalTo(50)
            $0.leadingMargin.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leadingMargin.equalTo(urlImageView.snp.trailing).offset(16)
            $0.trailingMargin.equalToSuperview().offset(-16)
        }
    }
}
