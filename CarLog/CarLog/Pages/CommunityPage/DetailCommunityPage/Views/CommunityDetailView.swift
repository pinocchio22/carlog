//
//  CommunityDetailView.swift
//  CarLog
//
//  Created by 김은경 on 11/13/23.
//

import UIKit

class CommunityDetailView: UIView {
    
    lazy var commentTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .singleLine
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: "CommentTableViewCell")
        return tableView
    }()
    
    lazy var communityDetailPageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    lazy var communityDetailPageContentView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "달려라 달려라~"
        label.textColor = .black
        label.font = UIFont.spoqaHanSansNeo(size: Constants.fontSize24, weight: .medium)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var userNameLabel: UIButton = {
        let button = UIButton()
        button.setTitle("왕바우", for: .normal) // "게시"라는 텍스트 설정
        button.setTitleColor(.black, for: .normal) // 텍스트 색상 설정
        button.titleLabel?.font = UIFont.spoqaHanSansNeo(size: Constants.fontSize14, weight: .medium) // 폰트와 크기 설정
        button.backgroundColor = .clear // 버튼의 배경색 설정
        return button
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.spoqaHanSansNeo(size: 12, weight: .medium)
        return label
    }()
    
    lazy var divideView = UIView()
    
    lazy var subTitleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [userNameLabel, divideView, dateLabel])
        stackView.customStackView(spacing: 0, axis: .horizontal, alignment: .center)
        stackView.distribution = .fill
        return stackView
    }()
    
    lazy var photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 345 )
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CommunityDetailCollectionViewCell.self, forCellWithReuseIdentifier: CommunityDetailCollectionViewCell.identifier)
        return collectionView
    }()
    
    lazy var emergencyButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    lazy var emergencyCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.spoqaHanSansNeo(size: Constants.fontSize14, weight: .bold)
        return label
    }()
    
    lazy var likeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emergencyButton, emergencyCountLabel])
        stackView.customStackView(spacing: 10, axis: .horizontal, alignment: .center)
        return stackView
    }()
    
    // textview 로 수정
    lazy var mainText: UILabel = {
        let label = UILabel()
        label.text = "카 \n로 \n그 \n언 \n더 \n독"
        label.textColor = .black
        label.font = UIFont.spoqaHanSansNeo(size: Constants.fontSize20, weight: .bold)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var line: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    lazy var commentUserNameLabel: UILabel = {
        let label = UILabel()
        label.text = "user1"
        label.font = UIFont.spoqaHanSansNeo(size: Constants.fontSize14, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var allStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subTitleStackView, photoCollectionView, likeStackView, mainText, line])
        stackView.customStackView(spacing: Constants.verticalMargin, axis: .vertical, alignment: .leading)
        stackView.distribution = .fill
        return stackView
    }()
    
    lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.text = "댓글..."
        label.font = UIFont.spoqaHanSansNeo(size: Constants.fontSize14, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    // 댓글
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundCoustomColor
        return view
    }()
    
    lazy var commentTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.font = UIFont.spoqaHanSansNeo(size: Constants.fontSize14, weight: .bold)
        textView.layer.cornerRadius = Constants.cornerRadius
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isUserInteractionEnabled = true
        textView.isEditable = true
        return textView
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("게시", for: .normal) // "게시"라는 텍스트 설정
        button.setTitleColor(.mainNavyColor, for: .normal) // 텍스트 색상 설정
        button.titleLabel?.font = UIFont.spoqaHanSansNeo(size: Constants.fontSize14, weight: .bold) // 폰트와 크기 설정
        button.backgroundColor = .clear // 버튼의 배경색 설정
        button.layer.cornerRadius = 5 // 버튼의 모서리 둥글게 설정
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        commentTableView.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
        
        emergencyButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
    }
}
