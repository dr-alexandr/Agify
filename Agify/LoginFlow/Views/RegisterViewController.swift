//
//  RegisterViewController.swift
//  Agify
//
//  Created by Dr.Alexandr on 14.11.2022.
//

import Foundation
import UIKit

final class RegisterViewController: UIViewController {
    
    var register: (() -> Void)?
    var goToLoginPage: (() -> Void)?
    
    let button = UIButton.getDefaultButton(title: "Register")
    let goToLoginButton = UIButton.getDefaultButton(title: "Login", font: 17, backgroundColor: UIColor(named: "LightBrown") ?? .gray, titleColor: .brown, underline: 1.0)
    let usernameLabel = UILabel.getDefaultLabel(text: "Username")
    let usernameTextfield = UITextField.getDefaultTextField(placeholder: "Enter username...", textAlignment: .left, font: 20, textColor: .brown, cornerRadius: 25, borderStyle: .roundedRect)
    let passwordLabel = UILabel.getDefaultLabel(text: "Password")
    let passwordTextfield = UITextField.getDefaultTextField(placeholder: "Enter username...", textAlignment: .left, font: 20, textColor: .brown, cornerRadius: 25, borderStyle: .roundedRect)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupUI()
    }
    
    private func setupLayout() {
        
        view.addSubview(passwordTextfield)
        passwordTextfield.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(50)
        }
        view.addSubview(passwordLabel)
        passwordLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(passwordTextfield).inset(50)
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(50)
        }
        view.addSubview(usernameTextfield)
        usernameTextfield.snp.makeConstraints { (make) in
            make.bottom.equalTo(passwordLabel).inset(50)
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(50)
        }
        view.addSubview(usernameLabel)
        usernameLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(usernameTextfield).inset(50)
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(50)
        }
        view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(100)
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(50)
        }
        view.addSubview(goToLoginButton)
        goToLoginButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(button).inset(55)
            make.height.equalTo(50)
            make.trailing.equalToSuperview().inset(50)
        }
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "LightBrown")
        button.addTarget(self, action: #selector(registerPressed), for: .touchUpInside)
        goToLoginButton.addTarget(self, action: #selector(goToLoginPressed), for: .touchUpInside)
    }
    
    @objc private func registerPressed() {
        guard usernameTextfield.text != "" else {return}
        guard passwordTextfield.text != "" else {return}
        guard let safePassword = passwordTextfield.text?.data(using: .utf8) else {return}
        do {
            try KeychainManager.save(service: "Agify",
                                     account: usernameTextfield.text!,
                                     password: safePassword)
            self.register?()
        } catch {
            print(error)
        }
    }
    
    @objc private func goToLoginPressed() {
        self.goToLoginPage?()
    }
}
