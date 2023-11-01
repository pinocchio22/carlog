//
//  FindIDPassWordViewController.swift
//  CarLog
//
//  Created by 김은경 on 10/31/23.
//
import UIKit

import SnapKit

class FindIDPassWordViewController: UIViewController {
    let findView = FindIDPasswordView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        addTarget()
        
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(findView.segmentedControl)
        view.addSubview(findView.findIDView)
        view.addSubview(findView.reSettingPasswordView)
        findView.reSettingPasswordView.addSubview(findView.emailTextField)
        findView.reSettingPasswordView.addSubview(findView.buttonStackView)
        
        findView.segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(Constants.horizontalMargin)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-Constants.horizontalMargin)
            make.height.equalTo(60)
        }
        
        findView.findIDView.snp.makeConstraints { make in
            make.top.equalTo(findView.segmentedControl.snp.bottom).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
        
        findView.reSettingPasswordView.snp.makeConstraints { make in
            make.top.equalTo(findView.segmentedControl.snp.bottom).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
        
        findView.emailTextField.snp.makeConstraints { make in
            make.top.equalTo(findView.reSettingPasswordView.snp.top).offset(Constants.verticalMargin)
            make.leading.equalTo(findView.reSettingPasswordView.snp.leading).offset(Constants.verticalMargin)
            make.trailing.equalTo(findView.reSettingPasswordView.snp.trailing).offset(-Constants.verticalMargin)
        }
        
        findView.buttonStackView.snp.makeConstraints { make in
            make.bottom.equalTo(findView.reSettingPasswordView.snp.bottom).offset(-Constants.verticalMargin)
            make.leading.equalTo(findView.reSettingPasswordView.snp.leading).offset(Constants.horizontalMargin)
            make.trailing.equalTo(findView.reSettingPasswordView.snp.trailing).offset(-Constants.horizontalMargin)
        }
    }
    
    private func addTarget() {
        findView.segmentedControl.addTarget(self, action: #selector(didChangeValue(segment:)), for: .valueChanged)
        findView.sendButton.addTarget(self, action: #selector(sendEmailTapped), for: .touchUpInside)
        
        findView.popButton.addAction(UIAction(handler: { _ in
            self.dismiss(animated: true)
        }), for: .touchUpInside)
    }
    
    @objc private func sendEmailTapped() {
        LoginService.loginService.sendPasswordReset(email: findView.emailTextField.text ?? "") { isSuccess, _ in
            if isSuccess {
                let alert = UIAlertController(title: "이메일로가서 비밀번호를 설정해주세요", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: {_ in 
                    self.dismiss(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc private func didChangeValue(segment: UISegmentedControl) {
        findView.shouldHideFirstView = segment.selectedSegmentIndex != 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
