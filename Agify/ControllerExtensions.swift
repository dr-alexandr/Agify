//
//  ControllerExtensions.swift
//  Agify
//
//  Created by Dr.Alexandr on 01.11.2022.
//

import Foundation
import UIKit

// MARK: - Keyboard settings
extension ViewController: UITextFieldDelegate {
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    // Return button action
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        buttonPressed()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
// MARK: - Navigation Control extension
extension ViewController: UINavigationControllerDelegate {
    func setRootNavControl() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Info", style: .plain, target: self, action: #selector(infoTapped))
        navigationController?.navigationBar.tintColor = UIColor.brown
    }
}
// MARK: - UILabel extension
extension UILabel {
    static func getDefaultLabel(text: String,
                                alignment: NSTextAlignment = .center,
                                font: CGFloat = 20,
                                textColor: UIColor = UIColor.brown) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = alignment
        label.font = UIFont.boldSystemFont(ofSize: font)
        label.textColor = textColor
        return label
    }
}

// MARK: - UIButton extension
extension UIButton {
    static func getDefaultButton(title: String,
                                font: CGFloat = 30,
                                backgroundColor: UIColor = UIColor(named: "LightBlue") ?? .brown,
                                titleColor: UIColor = .white) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitleColor(titleColor, for: .normal)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: font)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = 25
        return button
    }
}

// MARK: - UITextfield extension
extension UITextField {
    static func getDefaultTextField(placeholder: String,
                                    textAlignment: NSTextAlignment = .center,
                                    font: CGFloat = 30,
                                    textColor: UIColor = .brown,
                                    cornerRadius: CGFloat = 25,
                                    borderStyle: UITextField.BorderStyle = .none ) -> UITextField {
        let textfield = UITextField()
        textfield.backgroundColor = UIColor(named: "LightBrown")
        textfield.borderStyle = borderStyle
        textfield.placeholder = placeholder
        textfield.textAlignment = textAlignment
        textfield.font = UIFont.boldSystemFont(ofSize: font)
        textfield.textColor = textColor
        textfield.layer.cornerRadius = cornerRadius
        return textfield
    }
}

// MARK: - UITableViewCell extension
extension UITableViewCell {
    static func getDefaultTableCell() -> UITableViewCell {
        let tableCell = UITableViewCell()
        tableCell.selectionStyle = .none
        tableCell.backgroundColor = UIColor(named: "LightBrown")
        tableCell.textLabel?.textColor = UIColor.brown
        tableCell.textLabel?.numberOfLines = 0
        return tableCell
    }
}

// MARK: - Coordinator extension
extension UIViewController: Presentable {
    
    func toPresent() -> UIViewController? {
        return self
    }
}

