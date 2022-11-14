//
//  OnboardingViewController.swift
//  Agify
//
//  Created by Dr.Alexandr on 10.11.2022.
//

import Foundation
import UIKit

class OnboardingViewController: UIViewController {
    
    // MARK: - Properties
    var onboardingCompleted: (() -> Void)?
    
    // MARK: - UIElements
    private let onboardingText = UILabel.getDefaultLabel(text: "Hello! This app was made to test my coding skills. Test it!")
    private let onboardingButton = UIButton.getDefaultButton(title: "Start!", backgroundColor: .darkGray, titleColor: .white)
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setConstraints()
    }
    
    deinit {
        print("Deallocation \(self)")
    }
    
    // MARK: - Helpers
    private func setupUI() {
        view.backgroundColor = UIColor(named: "LightBrown")
        onboardingButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        onboardingText.numberOfLines = 0
    }
    
    // MARK: - Constraints
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
    
    // MARK: - Action
    @objc func buttonAction() {
        onboardingCompleted?()
    }
}
