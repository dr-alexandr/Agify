//
//  OnboardingViewController.swift
//  Agify
//
//  Created by Dr.Alexandr on 10.11.2022.
//

import Foundation
import UIKit

class OnboardingViewController: UIViewController {
    
    var onboardingCompleted: (() -> Void)?
    let onboardingText = UILabel.getDefaultLabel(text: "Hello! This app was made to test my coding skills. Test it!")
    let onboardingButton = UIButton.getDefaultButton(title: "Start!", backgroundColor: .darkGray, titleColor: .white)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setConstraints()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "LightBrown")
        onboardingButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        onboardingText.numberOfLines = 0
    }
    
    
    private func setConstraints() {
        view.addSubview(onboardingButton)
        onboardingButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.trailing.leading.equalToSuperview().inset(50)
            make.bottom.equalToSuperview().inset(100)
        }
        
        view.addSubview(onboardingText)
        onboardingText.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.trailing.leading.equalToSuperview().inset(50)
            make.centerY.equalToSuperview()
        }
    }
    
    @objc func buttonAction() {
        onboardingCompleted?()
    }
    
    
}
