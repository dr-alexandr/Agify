//
//  ViewController.swift
//  Agify
//
//  Created by Dr.Alexandr on 28.10.2022.
//

import UIKit
import SnapKit
import SwiftyJSON

class ViewController: UIViewController {
    
    // MARK: - UIElements
    
    let responseLabel = UILabel()
    let titleLabel = UILabel()
    let button = UIButton(type: .system)
    let textfield = UITextField()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        makeConstraints()
        
    }
    
    // MARK: - SetupUI
    
    func setupUI() {
        
        view.backgroundColor = UIColor(named: "LightBrown")
        
        //ResponseLabel
        responseLabel.text = "🕵🏻"
        responseLabel.textAlignment = .center
        responseLabel.textColor = UIColor.brown
        responseLabel.font = UIFont.boldSystemFont(ofSize: 75)
        view.addSubview(responseLabel)
        
        // Title label
        titleLabel.text = "Agify"
        titleLabel.textColor = UIColor.brown
        titleLabel.font = UIFont.boldSystemFont(ofSize: 50)
        view.addSubview(titleLabel)
        
        // Generate Button
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Generate", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button.backgroundColor = UIColor(named: "LightBlue")
        button.layer.cornerRadius = 25
        view.addSubview(button)
        
        //Generate Button target setup
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        // TextField
        textfield.placeholder = "Type a name here..."
        textfield.textAlignment = .center
        textfield.font = UIFont.boldSystemFont(ofSize: 30)
        textfield.textColor = UIColor.brown
        textfield.layer.cornerRadius = 25
        view.addSubview(textfield)
        
    }
    
    // MARK: - Constraints
    
    func makeConstraints() {
        
        // Response Label Constraints
        responseLabel.snp.makeConstraints { (responseLabel) in
            responseLabel.centerX.equalToSuperview()
            responseLabel.centerY.equalToSuperview()
            responseLabel.left.right.equalToSuperview().inset(50)
        }
        
        // Title label constraints
        titleLabel.snp.makeConstraints { (label) in
            label.bottom.equalTo(responseLabel).inset(250)
            label.centerX.equalToSuperview()
        }
        
        // Generate Button Constraints
        button.snp.makeConstraints { (button) in
            button.centerX.equalToSuperview()
            button.bottom.equalToSuperview().inset(100)
            button.left.right.equalToSuperview().inset(50)
            button.height.equalTo(50)
            
        }
        
        // TextField Constraints
        textfield.snp.makeConstraints { (textfield) in
            textfield.centerX.equalToSuperview()
            textfield.left.right.equalToSuperview().inset(50)
            textfield.bottom.equalTo(button).inset(100)
            textfield.height.equalTo(50)
        }
        
    }
    
    // MARK: - Button Action
    
    @objc func buttonPressed() {
        
        view.endEditing(true)
        
        if textfield.text != "" {
            getAge(name: textfield.text!)
        }
        
    }
    
    // MARK: - Data fetch
    
    func getAge(name: String) {
        var urlComponents = URLComponents(string: "https://api.agify.io/")!
        urlComponents.queryItems = [URLQueryItem(name: "name", value: name)]
        if let url = urlComponents.url?.absoluteURL {
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                if error != nil {
                    print("Task \(error!)")
                    return
                }
                
                if let safeData = data {
                    let json = JSON(safeData)
                    if let jsonAge = json["age"].int {
                        
                        DispatchQueue.main.async {
                            self.responseLabel.text = "\(jsonAge)"
                            
                        }
                        
                    }
                }
                
            }
            task.resume()
        }
        
    }
    
}
