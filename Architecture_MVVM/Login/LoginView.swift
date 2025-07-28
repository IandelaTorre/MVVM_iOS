//
//  ViewController.swift
//  Architecture_MVVM
//
//  Created by Ian Axel Perez de la Torre on 27/07/25.
//

import UIKit

class LoginView: UIViewController {
    private let loginViewModel = LoginViewModel(apiClient: APIClient())
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func loginButtonAction(_ sender: Any) {
        login()
    }
    
    private func login() {
        loginViewModel.userLogin(withEmail: emailTextField.text?.lowercased() ?? "", password: passwordTextField.text?.lowercased() ?? "")
    }
}

