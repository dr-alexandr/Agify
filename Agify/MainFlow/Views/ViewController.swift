//
//  ViewController.swift
//  Agify
//
//  Created by Dr.Alexandr on 28.10.2022.
//

import Foundation
import SnapKit

final class ViewController: UIViewController {
    
    // MARK: - UIElements
    private let responseLabel = UILabel.getDefaultLabel(text: "🕵🏻", font: 75)
    private let titleLabel = UILabel.getDefaultLabel(text: "Agify", font: 50)
    private let button = UIButton.getDefaultButton(title: "Generate")
    private let infoButton = UIButton.getDefaultButton(title: "Info")
    private let textfield = UITextField.getDefaultTextField(placeholder: "Type a name here...")
    private let loader = UIActivityIndicatorView()
    
    // MARK: - Properties
    var goToInfo: (() -> Void)?
    private var viewModel: ViewModelProtocol
    
    init(viewModel: ViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setRootNavControl()
        setupLayout()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        keyboardObserver()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeObservers()
    }
    
    // MARK: - Helpers
    private func keyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self, name:UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name:UIResponder.keyboardWillShowNotification, object: nil)    }
    
    private func bind() {
        viewModel.onCompletion = { [weak self] searchModel in
            self?.loader.stopAnimating()
            guard let self = self else { return }
            self.responseLabel.text = ("\(searchModel.age)")
            self.responseLabel.isHidden = false
        }
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "LightBrown")
        textfield.delegate = self
        
        // Button target setup
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        infoButton.addTarget(self, action: #selector(infoTapped), for: .touchUpInside)
    }
    
    // MARK: - Constraints
    
    private func setupLayout() {
        view.addSubview(responseLabel)
        responseLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(50)
        }
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(100)
            make.leading.trailing.equalToSuperview().inset(50)
            make.height.equalTo(50)
            
        }
        view.addSubview(textfield)
        textfield.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(50)
            make.bottom.equalTo(button.snp.bottom).inset(100)
            make.height.equalTo(50)
        }
        view.addSubview(infoButton)
        infoButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(100)
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(infoButton).inset(100)
            make.centerX.equalToSuperview()
        }
        view.addSubview(loader)
        loader.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.center.equalTo(responseLabel)
        }
        
    }
    
    // MARK: - Button Action
    @objc func buttonPressed() {
        view.endEditing(true)
        guard let text = textfield.text else {return}
        guard text != "" else {self.responseLabel.text = "🕵🏻"; return}
        self.responseLabel.isHidden = true
        loader.startAnimating()
        viewModel.getName(text)
    }
    
    @objc func infoTapped() {
        view.endEditing(true)
        self.goToInfo?()
    }
}
