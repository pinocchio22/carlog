//
//  DriveDetailViewController.swift
//  CarLog
//
//  Created by 김지훈 on 2023/10/18.
// 취소 수정버튼 히든처리 , 네비게이션바 아이템 수정 버튼 추가 // 주행기록 문구 네비게이션컨트롤러로

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class DriveDetailViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    var drivingData: Driving?
    
    //네비게이션바에 삭제 버튼 혹시나해서 만들어놓은거
    //    lazy var plusButton: UIBarButtonItem = {
    //        let plusButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(doDeleted))
    //        plusButton.tintColor = .mainNavyColor
    //        return plusButton
    //    }()
    //
    //    @objc func doDeleted() {
    //        print("--> go to AddPage")
    //
    //    }
    //
    //    func navigationUI() {
    //        self.navigationItem.rightBarButtonItem = self.plusButton
    //    }
    
    lazy var driveDetailView: DriveDetailView = {
        let driveDetailView = DriveDetailView()
        return driveDetailView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        //        navigationUI()
        
        view.addSubview(driveDetailView)
        driveDetailView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        loadDrivingData()
        
        driveDetailView.upDateButton.addTarget(self, action: #selector(didUpDateButton), for: .touchUpInside)
        driveDetailView.removeButton.addTarget(self, action: #selector(didCancelButton), for: .touchUpInside)
        
    }
    
    func loadDrivingData() {
        FirestoreService.firestoreService.loadDriving { drivingData in
            if let drivings = self.drivingData {
                self.driveDetailView.totalDistanceTextField.text = "\(drivings.departDistance ?? 0)"
                self.driveDetailView.arriveDistanceTextField.text = "\(drivings.arriveDistance ?? 0)"
                self.driveDetailView.driveDistenceTextField.text = "\(drivings.driveDistance ?? 0)"
            } else {
                print("데이터 로드 중 오류 발생")
            }
        }
    }
    
    @objc func didUpDateButton() {
        print("---> driveDetailView 수정 버튼 눌렀어요")
        
        if let drivingID = drivingData?.documentID {
            // 업데이트할 필드와 새 값의 딕셔너리를 구성합니다.
            var updatedData: [String: Any] = [:]
            
            if let totalDistanceText = self.driveDetailView.totalDistanceTextField.text, let totalDistance = Double(totalDistanceText) {
                updatedData["departDistance"] = totalDistance
            }
            
            if let arriveDistanceText = self.driveDetailView.arriveDistanceTextField.text, let arriveDistance = Double(arriveDistanceText) {
                updatedData["arriveDistance"] = arriveDistance
            }
            
            if let driveDistanceText = self.driveDetailView.driveDistenceTextField.text, let driveDistance = Double(driveDistanceText) {
                updatedData["driveDistance"] = driveDistance
            }
            
            FirestoreService.firestoreService.updateDriving(drivingID: drivingID, updatedData: updatedData) { error in
                if let error = error {
                    print("주행 데이터 업데이트 실패: \(error)")
                } else {
                    print("주행 데이터 업데이트 성공")
                    HistoryPageViewController().drivingCollectionView.drivingCollectionView.reloadData()
                    
                    if let navigationController = self.navigationController {
                        navigationController.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    @objc func didCancelButton() {
        print("---> driveDetailView 삭제 버튼 눌렀어요")
        
        if let drivingID = drivingData?.documentID {
            FirestoreService.firestoreService.removeDriving(drivingID: drivingID) { error in
                if let error = error {
                    print("주행 데이터 삭제 실패: \(error)")
                } else {
                    print("주행 데이터 삭제 성공")
                    HistoryPageViewController().drivingCollectionView.drivingCollectionView.reloadData()
                    
                    if let navigationController = self.navigationController {
                        navigationController.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    
}
