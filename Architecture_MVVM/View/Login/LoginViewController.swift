//
//  ViewController.swift
//  Architecture_MVVM
//
//  Created by Ian Axel Perez de la Torre on 27/07/25.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    private let loginViewModel = LoginViewModel(apiClient: APIClient())
    
    var cancellables = Set<AnyCancellable>()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createBindingViewWithViewModel()
        self.navigationController?.navigationItem.hidesBackButton = true
        
    }

    @IBAction func loginButtonAction(_ sender: Any) {
        loginTapped()
    }
    
    @IBAction func createAccountAction(_ sender: Any) {
    }
    
    @objc private func loginTapped() {
            guard
                let user = emailTextField.text,
                let password = passwordTextField.text,
                let time = Int("1")
            else {
                return
            }
            print("se hara petición")
            loginViewModel.login(user: user, password: password, time: time)
        }
    
    func createBindingViewWithViewModel() {
        emailTextField.textPublisher
            .assign(to: \LoginViewModel.email, on: loginViewModel)
            .store(in: &cancellables)
        
        passwordTextField.textPublisher
            .assign(to: \LoginViewModel.password, on: loginViewModel)
            .store(in: &cancellables)
        
        loginViewModel.$isEnabled
            .assign(to: \.isEnabled, on: loginButton)
            .store(in: &cancellables)
        
        loginViewModel.$showLoading
            .assign(to: \.configuration!.showsActivityIndicator, on: loginButton)
            .store(in: &cancellables)
        
        /*loginViewModel.$errorMessage
            .assign(to: \UILabel.text!, on: errorLabel)
            .store(in: &cancellables)*/
        
        loginViewModel.$userModel
            .receive(on: RunLoop.main)
            .sink { [weak self] user in
                guard user != nil else { return }
                self?.performSegue(withIdentifier: "loginToHome", sender: nil)
            }
            .store(in: &cancellables)
    }
}

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        return NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { notification in
                return (notification.object as? UITextField)?.text ?? ""
            }
            .eraseToAnyPublisher()
    }
}

