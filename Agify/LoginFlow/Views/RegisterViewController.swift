//
//  RegisterViewController.swift
//  Agify
//
//  Created by Dr.Alexandr on 14.11.2022.
//

import UIKit
import SnapKit

final class RegisterViewController: UIViewController {
    
    // MARK: - Properties
    var register: (() -> Void)?
    var goToLoginPage: (() -> Void)?
    
    // MARK: - UIElements
    private let button = UIButton.getDefaultButton(title: "Register")
    private let goToLoginButton = UIButton.getDefaultButton(title: "Login", font: 17, backgroundColor: UIColor(named: "LightBrown") ?? .gray, titleColor: .brown, underline: 1.0)
    private let usernameLabel = UILabel.getDefaultLabel(text: String.locString("Email"))
    private let usernameTextfield = UITextField.getDefaultTextField(placeholder: String.locString("Enter username..."), textAlignment: .left, font: 20, textColor: .brown, cornerRadius: 25, borderStyle: .roundedRect)
    private let passwordLabel = UILabel.getDefaultLabel(text: String.locString("Password"))
    private  let passwordTextfield = UITextField.getDefaultTextField(placeholder: String.locString("Enter password..."), textAlignment: .left, font: 20, textColor: .brown, cornerRadius: 25, borderStyle: .roundedRect, secure: true)
    private let logo = UIImage(named: "Icon")
    private let logoView = UIImageView()
    
    private var validMail = false
    private var validPassword = false
    private let emailPattern = #"^\S+@\S+\.\S+$"#
    private let passwordPattern = #"(?=.{8,})"# + #"(?=.*[A-Z])"# + #"(?=.*[a-z])"# + #"(?=.*\d)"#
    
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
        button.addTarget(self, action: #selector(registerPressed), for: .touchUpInside)
        goToLoginButton.addTarget(self, action: #selector(goToLoginPressed), for: .touchUpInside)
        usernameTextfield.addTarget(self, action: #selector(self.checkLogin(_:)), for: .editingChanged)
        passwordTextfield.addTarget(self, action: #selector(self.checkPassword(_:)), for: .editingChanged)
    }
    
    // MARK: - Constraints
    private func setupLayout() {
        view.addSubview(passwordTextfield)
        view.addSubview(passwordLabel)
        view.addSubview(usernameTextfield)
        view.addSubview(usernameLabel)
        view.addSubview(button)
        view.addSubview(goToLoginButton)
        view.addSubview(logoView)
        logoView.image = logo
        
        if compactWidth(self) {
            passwordTextfield.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
                make.height.equalTo(50)
                make.leading.trailing.equalToSuperview().inset(50)
            }
            passwordLabel.snp.makeConstraints { (make) in
                make.bottom.equalTo(passwordTextfield).inset(50)
                make.height.equalTo(50)
                make.leading.trailing.equalToSuperview().inset(50)
            }
            usernameTextfield.snp.makeConstraints { (make) in
                make.bottom.equalTo(passwordLabel).inset(50)
                make.height.equalTo(50)
                make.leading.trailing.equalToSuperview().inset(50)
            }
            usernameLabel.snp.makeConstraints { (make) in
                make.bottom.equalTo(usernameTextfield).inset(50)
                make.height.equalTo(50)
                make.leading.trailing.equalToSuperview().inset(50)
            }
            button.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().inset(100)
                make.height.equalTo(50)
                make.leading.trailing.equalToSuperview().inset(50)
            }
            goToLoginButton.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(button).inset(55)
                make.height.equalTo(50)
                make.trailing.equalToSuperview().inset(50)
            }
            logoView.snp.makeConstraints { (make) in
                make.width.height.equalTo(150)
                make.centerX.equalToSuperview()
                make.bottom.equalTo(usernameLabel).inset(40)
            }
        } else {
            passwordTextfield.font = UIFont.boldSystemFont(ofSize: 30)
            passwordTextfield.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
                make.height.equalTo(60)
                make.width.equalTo(500)
            }
            passwordLabel.font = UIFont.boldSystemFont(ofSize: 35)
            passwordLabel.snp.makeConstraints { (make) in
                make.bottom.equalTo(passwordTextfield).inset(70)
                make.height.equalTo(50)
                make.leading.trailing.equalToSuperview().inset(50)
            }
            usernameTextfield.font = UIFont.boldSystemFont(ofSize: 30)
            usernameTextfield.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(passwordLabel).inset(70)
                make.height.equalTo(60)
                make.width.equalTo(500)
            }
            usernameLabel.font = UIFont.boldSystemFont(ofSize: 35)
            usernameLabel.snp.makeConstraints { (make) in
                make.bottom.equalTo(usernameTextfield).inset(70)
                make.height.equalTo(50)
                make.leading.trailing.equalToSuperview().inset(50)
            }
            button.layer.cornerRadius = 40
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
            button.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().inset(150)
                make.height.equalTo(80)
                make.width.equalTo(500)
            }
            goToLoginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
            goToLoginButton.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(button).inset(100)
                make.height.equalTo(50)
                make.trailing.equalToSuperview().inset(50)
            }
            logoView.snp.makeConstraints { (make) in
                make.width.height.equalTo(300)
                make.centerX.equalToSuperview()
                make.bottom.equalTo(usernameLabel).inset(70)
            }
        }
    }
    
    // MARK: - Actions
    @objc private func registerPressed() {
        guard validMail == true && validPassword == true else {return}
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
    
    @objc private func checkLogin(_ textfield: UITextField) {
        let result = textfield.text?.range(of: emailPattern, options: .regularExpression)
        if result != nil {
            validMail = true
            textfield.textColor = UIColor(named: "LightBlue")
        } else {
            validMail = false
            textfield.textColor = UIColor(named: "Deny")
        }
    }
    
    @objc private func checkPassword(_ textfield: UITextField) {
        let result = textfield.text?.range(of: passwordPattern, options: .regularExpression)
        if result != nil {
            validPassword = true
            textfield.textColor = UIColor(named: "LightBlue")
        } else {
            validPassword = false
            textfield.textColor = UIColor(named: "Deny")
        }
    }
}
