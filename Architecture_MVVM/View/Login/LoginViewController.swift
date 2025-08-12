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
        if loginButton.configuration == nil {
            loginButton.configuration = .filled()
        }
        createBindingViewWithViewModel()
        
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
        
        loginViewModel.$showLoading
            .receive(on: RunLoop.main)
            .sink { [weak self] loading in
                guard let self = self, let button = self.loginButton else { return }
                var config = button.configuration ?? .filled()
                config.showsActivityIndicator = loading
                button.configuration = config
                button.isEnabled = loading ? false : self.loginViewModel.isEnabled
            }
            .store(in: &cancellables)
        
        loginViewModel.$isEnabled
            .receive(on: RunLoop.main)
            .sink { [weak self] enabled in
                guard let self = self else { return }
                self.loginButton.isEnabled = self.loginViewModel.showLoading ? false : enabled
            }
            .store(in: &cancellables)
        
        loginViewModel.$userModel
            .receive(on: RunLoop.main)
            .sink { [weak self] user in
                guard user != nil else { return }
                print("Debería cambiar a tabBar")
                self?.switchToMainTabBar()
            }
            .store(in: &cancellables)
    }
    
    private func switchToMainTabBar() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBar = sb.instantiateViewController(withIdentifier: "MainTabBar") as! UITabBarController

        // (Opcional) seleccionar tab inicial
        mainTabBar.selectedIndex = 0

        guard
            let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let sceneDelegate = scene.delegate as? SceneDelegate,
            let window = sceneDelegate.window
        else { return }

        window.rootViewController = mainTabBar
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
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

