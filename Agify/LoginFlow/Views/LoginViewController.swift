//
//  LoginViewController.swift
//  Agify
//
//  Created by Dr.Alexandr on 11.11.2022.
//

import UIKit
import SnapKit

final class LoginViewController: UIViewController {
    
    // MARK: - Properties
    var login: (() -> Void)?
    var goToRegisterPage: (() -> Void)?
    
    // MARK: - UIElements
    let button = UIButton.getDefaultButton(title: "Login")
    let goToRegisterButton = UIButton.getDefaultButton(title: "Registration", font: 17, backgroundColor: UIColor(named: "LightBrown") ?? .gray, titleColor: .brown, underline: 1.0)
    let usernameLabel = UILabel.getDefaultLabel(text: "Username")
    let usernameTextfield = UITextField.getDefaultTextField(placeholder: "Enter username...", textAlignment: .left, font: 20, textColor: .brown, cornerRadius: 25, borderStyle: .roundedRect)
    let passwordLabel = UILabel.getDefaultLabel(text: "Password")
    let passwordTextfield = UITextField.getDefaultTextField(placeholder: "Enter username...", textAlignment: .left, font: 20, textColor: .brown, cornerRadius: 25, borderStyle: .roundedRect, secure: true)
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupUI()
    }
    
    deinit {
        print("Deallocation \(self)")
    }
    
    // MARK: - Helpers
    private func setupUI() {
        view.backgroundColor = UIColor(named: "LightBrown")
        button.addTarget(self, action: #selector(loginPressed), for: .touchUpInside)
        goToRegisterButton.addTarget(self, action: #selector(goToRegisterPressed), for: .touchUpInside)
    }
    
    private func getPassword(account: String) -> String? {
        guard let data = KeychainManager.get(service: "Agify", account: account) else {
            print("getData func Failed")
            return nil
        }
        let password = String(decoding: data, as: UTF8.self)
        return password
    }
    
    // MARK: - Constraints
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
        view.addSubview(goToRegisterButton)
        goToRegisterButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(button).inset(55)
            make.height.equalTo(50)
            make.trailing.equalToSuperview().inset(50)
        }
    }
    
    // MARK: - Actions
    @objc private func loginPressed() {
        guard usernameTextfield.text != "" else {return}
        guard passwordTextfield.text != "" else {return}
        guard passwordTextfield.text == getPassword(account: usernameTextfield.text!) else {return}
        self.login?()
    }
    
    @objc private func goToRegisterPressed() {
        self.goToRegisterPage?()
    }
    
}
