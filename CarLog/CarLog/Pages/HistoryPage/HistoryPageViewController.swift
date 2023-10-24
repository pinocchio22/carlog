import SnapKit
import UIKit

class HistoryPageViewController: UIViewController {
    
    var drivingDummy: [Driving] = []
    
    var fuelingDummy = [
        Fueling(timeStamp: "2023.10.15", id: "1", totalDistance: 23, price: 1789, count: 10, totalPrice: 17890, userEmail: "hhn0212@naver.com")
    ]
    
    lazy var noDataLabel: UILabel = {
        let noDataLabel = UILabel()
        noDataLabel.customLabel(text: "주행기록을 추가해서 차를 관리하세요!", textColor: .gray, font: UIFont.spoqaHanSansNeo(size: Constants.fontJua20, weight: .bold), alignment: .center)
        noDataLabel.isHidden = true
        return noDataLabel
    }()
    
    lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["주행 기록", "주유 내역"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(didChangeValue(segment:)), for: .valueChanged)
        segmentedControl.selectedSegmentTintColor = .mainNavyColor
        
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.spoqaHanSansNeo(size: Constants.fontJua20, weight: .bold), .foregroundColor: UIColor.darkGray], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.spoqaHanSansNeo(size: Constants.fontJua20, weight: .bold), .foregroundColor: UIColor.white], for: .selected)
        return segmentedControl
    }()
    
    lazy var drivingCollectionView: DrivingView = {
        let drivingCollectionView = DrivingView()
        drivingCollectionView.drivingCollectionView.dataSource = self
        drivingCollectionView.drivingCollectionView.delegate = self
        drivingCollectionView.drivingCollectionView.register(DrivingCollectionViewCell.self, forCellWithReuseIdentifier: DrivingCollectionViewCell.identifier)
        drivingCollectionView.drivingCollectionView.backgroundColor = .white
        return drivingCollectionView
    }()
    
    lazy var fuelingCollectionView: FuelingView = {
        let fuelingCollectionView = FuelingView()
        fuelingCollectionView.fuelingCollectionView.dataSource = self
        fuelingCollectionView.fuelingCollectionView.delegate = self
        fuelingCollectionView.fuelingCollectionView.register(FuelingCollectionViewCell.self, forCellWithReuseIdentifier: FuelingCollectionViewCell.identifier)
        fuelingCollectionView.fuelingCollectionView.backgroundColor = .white
        return fuelingCollectionView
    }()
    
    var shouldHideFirstView: Bool? {
        didSet {
            guard let shouldHideFirstView = self.shouldHideFirstView else { return }
            self.drivingCollectionView.isHidden = shouldHideFirstView
            self.fuelingCollectionView.isHidden = !self.drivingCollectionView.isHidden
        }
    }
    
    lazy var floatingButtonStackView: FloatingButtonStackView = {
        let floatingButtonStackView = FloatingButtonStackView()
        floatingButtonStackView.navigationController = self.navigationController
        return floatingButtonStackView
    }()
    
    var ac: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        setupUI()
        self.didChangeValue(segment: self.segmentedControl)
        buttonActions()
        
        loadDrivingData()
        
        //indicator 추가
        ac = UIActivityIndicatorView(style: .medium)
        ac.center = view.center
        view.addSubview(ac)
        ac.startAnimating()
        
        //NotificationCenter addDriving 연결하기
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewDrivingRecordAdded(_:)), name: .newDrivingRecordAdded, object: nil)
    }
    
    //NotificationCenter newDriving 배열 맨 위에 저장하기
    @objc func handleNewDrivingRecordAdded(_ notification: Notification) {
        if let newDriving = notification.object as? Driving {
            drivingDummy.insert(newDriving, at: 0)
            drivingCollectionView.drivingCollectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        loadDrivingData()
    }
    
    @objc private func didChangeValue(segment: UISegmentedControl) {
        self.shouldHideFirstView = segment.selectedSegmentIndex != 0
    }
    
    func setupUI() {
        view.addSubview(segmentedControl)
        view.addSubview(drivingCollectionView)
        view.addSubview(fuelingCollectionView)
        view.addSubview(floatingButtonStackView)
        
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(Constants.horizontalMargin)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-Constants.horizontalMargin)
            make.height.equalTo(60)
        }
        
        drivingCollectionView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        fuelingCollectionView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        floatingButtonStackView.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-Constants.horizontalMargin)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-Constants.horizontalMargin)
        }
    
    }
    
    func buttonActions() {
        
        floatingButtonStackView.floatingButton.addAction(UIAction(handler: {_ in
            self.isActive.toggle()
        }), for: .touchUpInside)
        
        floatingButtonStackView.fuelingButton.addAction(UIAction(handler: {_ in
            self.navigationController?.present(AddFuelingViewController(), animated: true)
            self.navigationController?.modalPresentationStyle = .fullScreen
        }), for: .touchUpInside)
        
        floatingButtonStackView.drivingButton.addAction(UIAction(handler: {_ in
            self.navigationController?.present(AddDrivingViewController(), animated: true)
            self.navigationController?.modalPresentationStyle = .fullScreen
        }), for: .touchUpInside)
        
    }
    
    private var animation: UIViewPropertyAnimator?
    
    private var isActive: Bool = false {
        didSet {
            showActionButtons()
        }
    }
    
    private func showActionButtons() {
        popButtons()
        rotateFloatingButton()
    }
    
    private func popButtons() {
        if isActive {
            floatingButtonStackView.fuelingButton.layer.transform = CATransform3DMakeScale(0.4, 0.4, 1)
            UIView.animate(withDuration: 0.3, delay: 0.2, usingSpringWithDamping: 0.55, initialSpringVelocity: 0.3, options: [.curveEaseInOut], animations: { [weak self] in
                guard let self = self else { return }
                floatingButtonStackView.fuelingButton.layer.transform = CATransform3DIdentity
                floatingButtonStackView.fuelingButton.alpha = 1.0
            })
            
            floatingButtonStackView.drivingButton.layer.transform = CATransform3DMakeScale(0.4, 0.4, 1)
            UIView.animate(withDuration: 0.3, delay: 0.2, usingSpringWithDamping: 0.55, initialSpringVelocity: 0.3, options: [.curveEaseInOut], animations: { [weak self] in
                guard let self = self else { return }
                floatingButtonStackView.drivingButton.layer.transform = CATransform3DIdentity
                floatingButtonStackView.drivingButton.alpha = 1.0
            })
        } else {
            UIView.animate(withDuration: 0.15, delay: 0.2, options: []) { [weak self] in
                guard let self = self else { return }
                floatingButtonStackView.fuelingButton.layer.transform = CATransform3DMakeScale(0.4, 0.4, 0.1)
                floatingButtonStackView.fuelingButton.alpha = 0.0
            }
            
            UIView.animate(withDuration: 0.15, delay: 0.2, options: []) { [weak self] in
                guard let self = self else { return }
                floatingButtonStackView.drivingButton.layer.transform = CATransform3DMakeScale(0.4, 0.4, 0.1)
                floatingButtonStackView.drivingButton.alpha = 0.0
            }
        }
    }
    
    private func rotateFloatingButton() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        let fromValue = isActive ? 0 : CGFloat.pi / 4
        let toValue = isActive ? CGFloat.pi / 4 : 0
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.duration = 0.3
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        floatingButtonStackView.floatingButton.layer.add(animation, forKey: nil)
    }
    
    func loadDrivingData() {
        FirestoreService.firestoreService.loadDriving { result in
            if let drivings = result {
                self.drivingDummy = drivings.sorted(by: { $0.timeStamp?.toDateDetail() ?? Date() < $1.timeStamp?.toDateDetail() ?? Date() })
                DispatchQueue.main.async {
                    self.drivingCollectionView.drivingCollectionView.reloadData()
                    self.ac.stopAnimating()
                    self.ac.isHidden = true
                }
            } else {
                print("데이터 로드 중 오류 발생")
            }
        }
    }

}

extension HistoryPageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == drivingCollectionView.drivingCollectionView {
            return drivingDummy.count
        } else {
            return fuelingDummy.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == drivingCollectionView.drivingCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DrivingCollectionViewCell.identifier, for: indexPath) as? DrivingCollectionViewCell else { return UICollectionViewCell() }
            
            cell.backgroundColor = .buttonSkyBlueColor
            cell.layer.borderWidth = 2
            cell.layer.cornerRadius = Constants.cornerRadius * 4
            
            cell.layer.borderColor = UIColor.systemGray5.cgColor
            cell.layer.shadowColor = UIColor.gray.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 2)
            cell.layer.shadowRadius = 3
            cell.layer.shadowOpacity = 0.3
            
            cell.writeDateLabel.text = drivingDummy[indexPath.row].timeStamp ?? ""
            cell.driveDistenceLabel.text = String("\(drivingDummy[indexPath.row].driveDistance ?? 0.0)km")
            cell.arriveTotalDistenceLabel.text = String("\(drivingDummy[indexPath.row].arriveDistance ?? 0.0)km")
            
            return cell
            
        } else if collectionView == fuelingCollectionView.fuelingCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FuelingCollectionViewCell.identifier, for: indexPath) as? FuelingCollectionViewCell else { return UICollectionViewCell() }
            
            cell.backgroundColor = .white
            cell.layer.borderWidth = 2
            cell.layer.cornerRadius = Constants.cornerRadius
            
            cell.layer.borderColor = UIColor.systemGray5.cgColor
            cell.layer.shadowColor = UIColor.gray.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 2)
            cell.layer.shadowRadius = 3
            cell.layer.shadowOpacity = 0.3
            
            cell.writeDateLabel.text = fuelingDummy[indexPath.row].timeStamp!
            cell.priceLabel.text = String("\(fuelingDummy[indexPath.row].price!)원")
            cell.totalPriceLabel.text = String("\(fuelingDummy[indexPath.row].totalPrice!)원")
            cell.countLabel.text = String("\(fuelingDummy[indexPath.row].count!)L")
            
            return cell
        }
        
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - Constants.horizontalMargin * 4), height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == drivingCollectionView.drivingCollectionView {
            let driveDetailViewController = DriveDetailViewController()
            //
            driveDetailViewController.drivingData = drivingDummy[indexPath.row]
            self.navigationController?.pushViewController(driveDetailViewController, animated: true)
        } else if collectionView == fuelingCollectionView.fuelingCollectionView {
            let fuelingDetailViewController = FuelingDetailViewController()
            self.navigationController?.pushViewController(fuelingDetailViewController, animated: true)
        }
    }

}
