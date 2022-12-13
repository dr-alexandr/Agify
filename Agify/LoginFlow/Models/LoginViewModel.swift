//
//  LoginViewModel.swift
//  Agify
//
//  Created by Dr.Alexandr on 13.12.2022.
//

import Foundation
import UIKit

protocol LoginViewModelProtocol {
    var validMail : Bool { get set }
    var validPassword : Bool { get set }
    var emailPattern : String { get }
    var passwordPattern : String { get }
    func validCredentials() -> Bool
    func getPassword(account: String) -> String?
    func checkLogin(_ login: String) -> UIColor
    func checkPassword(_ password: String) -> UIColor
}

class LoginViewModel: LoginViewModelProtocol {
    var validMail = false
    var validPassword = false
    let emailPattern = #"^\S+@\S+\.\S+$"#
    let passwordPattern = #"(?=.{8,})"# + #"(?=.*[A-Z])"# + #"(?=.*[a-z])"# + #"(?=.*\d)"#
    
    func validCredentials() -> Bool {
        if validMail == true && validPassword == true {return true} else {return false}
    }
    
    func checkLogin(_ login: String) -> UIColor {
        let result = login.range(of: emailPattern, options: .regularExpression)
        if result != nil {
            validMail = true
            return UIColor(named: "LightBlue") ?? .green
        } else {
            validMail = false
            return UIColor(named: "Deny") ?? .red
        }
    }
    
    func checkPassword(_ password: String) -> UIColor {
        let result = password.range(of: passwordPattern, options: .regularExpression)
        if result != nil {
            validPassword = true
            return UIColor(named: "LightBlue") ?? .green
        } else {
            validPassword = false
            return UIColor(named: "Deny") ?? .red
        }
    }
    
    func getPassword(account: String) -> String? {
        guard let data = KeychainManager.get(service: "Agify", account: account) else {
            print("getData func Failed")
            return nil
        }
        let password = String(decoding: data, as: UTF8.self)
        return password
    }
}
