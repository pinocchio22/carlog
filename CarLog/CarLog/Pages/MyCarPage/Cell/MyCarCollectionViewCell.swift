//
//  MyPageTableViewCell.swift
//  CarLog
//
//  Created by t2023-m0056 on 2023/10/11.
//

import UIKit

import SnapKit

class MyCarCollectionViewCell: UICollectionViewCell {
    // MARK: Properties

    private var collectionViewImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "photo")
        return view
    }()
    
    private var collectionViewTitle: UILabel = {
        var label = UILabel()
        label.customLabel(text: "이름", textColor: .black, font: UIFont.spoqaHanSansNeo(size: Constants.fontSize16, weight: .bold), alignment: .left)
        return label
    }()
    
    private lazy var progressView: UIProgressView = {
        let view = UIProgressView()
        view.trackTintColor = .buttonSkyBlueColor
        view.progressTintColor = .mainNavyColor
        view.progress = 0.1
        return view
    }()
    
    private var interval: UILabel = {
        var label = UILabel()
        label.customLabel(text: "설정 기간", textColor: .systemGray, font: UIFont.spoqaHanSansNeo(size: Constants.fontSize10, weight: .medium), alignment: .left)
        return label
    }()
    
    private let clickedIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "chevron.forward")
        view.tintColor = .mainNavyColor
        return view
    }()
    
    let tooltipIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "questionmark.circle")
        view.tintColor = .lightGray
        return view
    }()
    
    var tooltipTapped: (() -> Void)?
    
    // MARK: LifeCycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupTooltipIcon()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Method

    private func setupUI() {
        contentView.addSubview(collectionViewImage)
        contentView.addSubview(clickedIcon)
        contentView.addSubview(collectionViewTitle)
        contentView.addSubview(progressView)
        contentView.addSubview(interval)
        contentView.addSubview(tooltipIcon)
            
        contentView.layer.cornerRadius = Constants.cornerRadius * 4
        contentView.backgroundColor = .white
        
        contentView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Constants.horizontalMargin)
            $0.height.equalTo(100)
        }
        
        collectionViewImage.snp.makeConstraints {
            $0.leading.equalTo(contentView).inset(Constants.horizontalMargin)
            $0.width.height.equalTo(60)
            $0.centerY.equalTo(contentView)
        }
        
        collectionViewTitle.snp.makeConstraints {
            $0.top.equalTo(contentView).inset(Constants.verticalMargin)
            $0.leading.equalTo(collectionViewImage.snp.trailing).inset(-Constants.horizontalMargin)
            $0.trailing.equalTo(clickedIcon.snp.leading).inset(-Constants.horizontalMargin)
        }
        
        progressView.snp.makeConstraints {
            $0.top.equalTo(collectionViewTitle.snp.bottom).inset(-Constants.verticalMargin)
            $0.leading.equalTo(collectionViewImage.snp.trailing).inset(-Constants.horizontalMargin)
            $0.trailing.equalTo(clickedIcon.snp.leading).inset(-Constants.horizontalMargin)
            $0.height.equalTo(4)
            $0.centerY.equalTo(contentView)
        }
        
        interval.snp.makeConstraints {
            $0.top.equalTo(progressView.snp.bottom).inset(-Constants.verticalMargin)
            $0.leading.equalTo(collectionViewImage.snp.trailing).inset(-Constants.horizontalMargin)
            $0.trailing.equalTo(clickedIcon.snp.leading).inset(-Constants.horizontalMargin)
            $0.bottom.equalTo(contentView).inset(Constants.verticalMargin)
        }
        
        clickedIcon.snp.makeConstraints {
            $0.trailing.equalTo(contentView).inset(Constants.horizontalMargin)
            $0.centerY.equalTo(contentView)
            $0.width.equalTo(15)
            $0.height.equalTo(20)
        }
        
        tooltipIcon.snp.makeConstraints {
            $0.top.trailing.equalTo(contentView).inset(Constants.horizontalMargin)
            $0.size.equalTo(15)
        }
    }
    
    func bind(title: String, interval: String, icon: UIImage, progress: Double) {
        collectionViewTitle.text = title
        self.interval.text = interval
        progressView.progress = Float(progress)
        collectionViewImage.image = icon
    }
    
    func setupTooltipIcon() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTooltipTap))
            tooltipIcon.addGestureRecognizer(tapGesture)
            tooltipIcon.isUserInteractionEnabled = true
        }
    
    @objc func handleTooltipTap() {
           tooltipTapped?()
       }
}
