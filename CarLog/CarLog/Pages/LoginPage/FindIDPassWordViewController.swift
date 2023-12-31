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
        view.backgroundColor = .backgroundCoustomColor
        setupUI()
        addTarget()
        
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(findView.passwordLabel)
        view.addSubview(findView.emailTextField)
        view.addSubview(findView.buttonStackView)
        
        findView.passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.horizontalMargin)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(Constants.horizontalMargin)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-Constants.horizontalMargin)
        }

        findView.emailTextField.snp.makeConstraints { make in
            make.top.equalTo(findView.passwordLabel.snp.bottom).offset(Constants.verticalMargin * 2)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(Constants.verticalMargin)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-Constants.verticalMargin)
        }
        
        findView.buttonStackView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-Constants.verticalMargin)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(Constants.horizontalMargin)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-Constants.horizontalMargin)
        }
    }
    
    private func addTarget() {
        findView.buttonStackView.firstButton.addTarget(self, action: #selector(sendEmailTapped), for: .touchUpInside)
        
        findView.buttonStackView.secondButton.addAction(UIAction(handler: { _ in
            self.dismiss(animated: true)
        }), for: .touchUpInside)
    }
    
    @objc private func sendEmailTapped() {
        LoginService.loginService.sendPasswordReset(email: findView.emailTextField.text ?? "") { isSuccess, _ in
            if isSuccess {
                self.showAlert(message: "이메일로가서 비밀번호를 설정해주세요") {
                    self.dismiss(animated: true)
                }
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
