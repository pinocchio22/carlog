//
//  MyCarPageDetailViewController.swift
//  CarLog
//
//  Created by t2023-m0056 on 2023/10/18.
//

import SnapKit
import SwiftUI
import UIKit

class MyCarDetailPageViewController: UIViewController {
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .thirdColor
        view.layer.cornerRadius = Constants.cornerRadius
        return view
    }()
    
    private var selectedTitleLabel: UILabel = {
        var label = UILabel()
        label.customLabel(text: "이름", textColor: .black, font: Constants.fontJua16 ?? UIFont.systemFont(ofSize: 16), alignment: .left)
        return label
    }()

    lazy private var selectedprogressView: UIProgressView = {
        let view = UIProgressView()
        view.trackTintColor = .white
        view.progressTintColor = .primaryColor
        view.progress = 0.1
        return view
    }()
    
    private var selectedIntervalLabel: UILabel = {
        var label = UILabel()
        label.customLabel(text: "기간", textColor: .systemGray, font: Constants.fontJua10 ?? UIFont.systemFont(ofSize: 10), alignment: .left)
        return label
    }()
    
    private let selectedIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "chevron.forward")
        view.tintColor = .primaryColor
        return view
    }()
    
    lazy private var buttonStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [modifiedButton, completedButton])
        view.customStackView(spacing: Constants.horizontalMargin * 2, axis: .horizontal, alignment: .fill)
        view.distribution = .fillEqually
        return view
    }()
    
    private let modifiedButton: UIButton = {
        let button = UIButton()
        button.customButton(text: "수정", font: Constants.fontJua20 ?? UIFont.systemFont(ofSize: 20), titleColor: .white, backgroundColor: .primaryColor)
        return button
    }()
    
    private let completedButton: UIButton = {
        let button = UIButton()
        button.customButton(text: "완료", font: Constants.fontJua20 ?? UIFont.systemFont(ofSize: 20), titleColor: .white, backgroundColor: .primaryColor)
        return button
    }()
    
    private let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return layout
    }()
    
    private lazy var detailCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
        view.isScrollEnabled = true
        view.showsVerticalScrollIndicator = true
        view.backgroundColor = .systemBackground
        view.clipsToBounds = true
        view.register(MyCarDetialViewCell.self, forCellWithReuseIdentifier: MyCarDetialViewCell.identifier)
        return view
    }()
    
    // MARK: Dummy
    private let dummyList = [Detail(date: "2023 / 10 / 18", type: "수정"), Detail(date: "2023 / 10 / 19", type: "교체"), Detail(date: "2023 / 10 / 19", type: "교체"), Detail(date: "2023 / 10 / 19", type: "교체"), Detail(date: "2023 / 10 / 19", type: "교체"), Detail(date: "2023 / 10 / 19", type: "교체"), Detail(date: "2023 / 10 / 19", type: "교체"), Detail(date: "2023 / 10 / 19", type: "교체"), Detail(date: "2023 / 10 / 19", type: "교체"), Detail(date: "2023 / 10 / 19", type: "교체"), Detail(date: "2023 / 10 / 19", type: "교체"), Detail(date: "2023 / 10 / 19", type: "교체"), Detail(date: "2023 / 10 / 19", type: "교체")]
    
    var dummyMenu = Menu(title: "", interval: "", icon: UIImage(systemName: "photo")!)
    
    struct Detail {
        let date: String
        let type: String
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupUI()
        setCollectionView()
        configure()
    }
    
    private func setupUI() {
        view.addSubview(backgroundView)
        view.addSubview(buttonStackView)
        view.addSubview(detailCollectionView)
        
        backgroundView.addSubview(selectedTitleLabel)
        backgroundView.addSubview(selectedprogressView)
        backgroundView.addSubview(selectedIntervalLabel)
        backgroundView.addSubview(selectedIcon)
        
        backgroundView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(Constants.horizontalMargin)
        }
        
        selectedIcon.snp.makeConstraints {
            $0.top.leading.bottom.equalTo(backgroundView).inset(Constants.horizontalMargin)
            $0.width.height.equalTo(60)
            $0.centerY.equalTo(backgroundView)
        }
        
        selectedTitleLabel.snp.makeConstraints {
            $0.top.trailing.equalTo(backgroundView).inset(Constants.horizontalMargin)
            $0.leading.equalTo(selectedIcon.snp.trailing).inset(-Constants.verticalMargin)
        }
        
        selectedprogressView.snp.makeConstraints {
            $0.top.equalTo(selectedTitleLabel.snp.bottom).inset(-Constants.verticalMargin)
            $0.leading.equalTo(selectedIcon.snp.trailing).inset(-Constants.horizontalMargin)
            $0.trailing.equalTo(backgroundView).inset(Constants.horizontalMargin)
        }
        
        selectedIntervalLabel.snp.makeConstraints {
            $0.top.equalTo(selectedprogressView.snp.bottom).inset(-Constants.verticalMargin)
            $0.leading.equalTo(selectedIcon.snp.trailing).inset(-Constants.horizontalMargin)
            $0.trailing.equalTo(backgroundView).inset(Constants.horizontalMargin)
            $0.bottom.equalTo(backgroundView).inset(Constants.verticalMargin)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(backgroundView.snp.bottom).inset(-Constants.verticalMargin)
            $0.leading.trailing.equalToSuperview().inset(Constants.horizontalMargin)
        }
        
        detailCollectionView.snp.makeConstraints {
            $0.top.equalTo(buttonStackView.snp.bottom).inset(-Constants.verticalMargin)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        modifiedButton.snp.makeConstraints {
            $0.height.equalTo(60)
        }
        
        completedButton.snp.makeConstraints {
            $0.height.equalTo(60)
        }
    }
    
    private func configure() {
        selectedTitleLabel.text = dummyMenu.title
        selectedIntervalLabel.text = dummyMenu.interval
        selectedIcon.image = dummyMenu.icon
    }
    
    private func setCollectionView() {
        detailCollectionView.delegate = self
        detailCollectionView.dataSource = self
    }
}

extension MyCarDetailPageViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCarDetialViewCell.identifier, for: indexPath) as? MyCarDetialViewCell else { return UICollectionViewCell() }
        cell.bind(date: dummyList[indexPath.row].date, type: dummyList[indexPath.row].type)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.bounds.width - Constants.horizontalMargin, height: 50)
    }
}

// SwiftUI를 활용한 미리보기
struct MyCarDetailViewController_Previews: PreviewProvider {
    static var previews: some View {
        MyCarDetailVCReprsentable().edgesIgnoringSafeArea(.all)
    }
}

struct MyCarDetailVCReprsentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let myCarDetailVC = MyCarDetailPageViewController()
        return UINavigationController(rootViewController: myCarDetailVC)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    typealias UIViewControllerType = UIViewController
}
