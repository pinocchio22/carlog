//
//  communityPageCollectionViewCell.swift
//  CarLog
//
//  Created by t2023-m0075 on 10/30/23.
//

import UIKit

class CommunityPageCollectionViewCell: UICollectionViewCell {
    lazy var userName: UILabel = {
        let label = UILabel()
        label.text = "왕바우"
        label.textColor = .black
        label.font = UIFont.spoqaHanSansNeo(size: 12, weight: .medium)
        return label
    }()
    
    lazy var spanerImage: UIImageView = {
        let imageView = UIImageView()
        if let image = UIImage(named: "spaner") {
            imageView.image = image
        }
        return imageView
    }()
    
    lazy var commentImage: UIImageView = {
        let imageView = UIImageView()
        if let image = UIImage(named: "comment") {
            imageView.image = image
        }
        return imageView
    }()
    
    lazy var spanerCounts: UILabel = {
        let label = UILabel()
        label.text = "-1"
        label.textColor = .black
        label.font = UIFont.spoqaHanSansNeo(size: 12, weight: .medium)
        return label
    }()
    
    lazy var commentCounts: UILabel = {
        let label = UILabel()
        label.text = "-1"
        label.textColor = .black
        label.font = UIFont.spoqaHanSansNeo(size: 12, weight: .medium)
        return label
    }()
    
    lazy var collectionViewImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "defaultImage")
        imageView.layer.cornerRadius = Constants.cornerRadius
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "제목"
        label.textColor = .black
        label.font = UIFont.spoqaHanSansNeo(size: Constants.fontSize24, weight: .medium)
        return label
    }()
    
    lazy var mainTextLabel: UILabel = {
        let label = UILabel()
        label.text = "본문"
        label.textColor = .black
        label.font = UIFont.spoqaHanSansNeo(size: Constants.fontSize20, weight: .medium)
        return label
    }()
    
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [userName, UIView(), iconStackView])
        stackView.customStackView(spacing: Constants.horizontalMargin, axis: .horizontal, alignment: .center)
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var iconStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [spanerImage, spanerCounts, commentImage, commentCounts])
        stackView.customStackView(spacing: Constants.horizontalMargin, axis: .horizontal, alignment: .center)
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.collectionViewImage.image = UIImage(named: "defaultImage")
        self.titleLabel.text = ""
        self.mainTextLabel.text = ""
    }
    
    private func setupUI() {
        contentView.addSubview(topStackView)
        contentView.addSubview(collectionViewImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(mainTextLabel)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = Constants.cornerRadius * 2
        contentView.layer.masksToBounds = true
        
        spanerImage.snp.makeConstraints { make in
            make.width.height.equalTo(17)
        }
        
        commentImage.snp.makeConstraints { make in
            make.width.height.equalTo(17)
        }
        
        topStackView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(Constants.verticalMargin)
            make.leading.equalTo(contentView.snp.leading).offset(Constants.horizontalMargin)
            make.trailing.equalTo(contentView.snp.trailing).offset(-Constants.horizontalMargin)
        }

        collectionViewImage.snp.makeConstraints { make in
            make.top.equalTo(topStackView.snp.bottom).offset(Constants.verticalMargin)
            make.leading.equalTo(contentView.snp.leading).offset(Constants.horizontalMargin)
            make.trailing.equalTo(contentView.snp.trailing).offset(-Constants.horizontalMargin)
            make.height.equalTo(180)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionViewImage.snp.bottom).offset(Constants.verticalMargin)
            make.leading.equalTo(contentView.snp.leading).offset(Constants.horizontalMargin)
            make.trailing.equalTo(contentView.snp.trailing).offset(-Constants.horizontalMargin)
        }
        
        mainTextLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.verticalMargin)
            make.leading.equalTo(contentView.snp.leading).offset(Constants.horizontalMargin)
            make.trailing.equalTo(contentView.snp.trailing).offset(-Constants.horizontalMargin)
        }
    }
    
    func bind(userName: String?, title: String?, content: String?, image: URL?, spanerCount: Int?, commentCount: Int?) {
        self.userName.text = userName
        self.titleLabel.text = title
        self.mainTextLabel.text = content
        if let image = image {
            self.collectionViewImage.load(url: image)
        }
        self.spanerCounts.text = String(spanerCount ?? 0)
        self.commentCounts.text = String(commentCount ?? 0)
    }
}
