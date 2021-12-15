import UIKit

class RegisterVC: UIViewController {
    
    let imageView = UIImageView()
    let userNameField = UITextField()
    let passwordField = UITextField()
    
    let loginButton   = CustomButton(backgroundColor: .systemOrange, title: "Kayıt Ol")
    let button = UIButton(type: .custom)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureImageView()
        confiureTextField()
        configurePasswordField()
        configureSignButton()
    }
    
    private func configureImageView(){
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "logo")
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 240),
            imageView.heightAnchor.constraint(equalToConstant: 130)
        ])
    }
    
    private func confiureTextField(){
        view.addSubview(userNameField)
        
        userNameField.translatesAutoresizingMaskIntoConstraints = false
        userNameField.placeholder = "your@mail.com"
        userNameField.borderStyle = .roundedRect
        
        NSLayoutConstraint.activate([
            userNameField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            userNameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            userNameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            userNameField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configurePasswordField(){
        view.addSubview(passwordField)
        
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.placeholder = "Şifre"
        passwordField.borderStyle = .roundedRect
        passwordField.isSecureTextEntry = true
        
        passwordField.rightViewMode = .always
        
        
        button.setImage(SFSymbols.eyeSlash, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 10)
        button.frame = CGRect(x: 5, y: CGFloat(5), width: 10, height: 10)
        button.tintColor = .lightGray
        button.addTarget(self, action: #selector(hideOrShowPassword), for: .touchUpInside)
        passwordField.rightView = button
        
        NSLayoutConstraint.activate([
            passwordField.topAnchor.constraint(equalTo: userNameField.bottomAnchor, constant: 10),
            passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            passwordField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureSignButton(){
        view.addSubview(loginButton)
        
        loginButton.addTarget(self, action: #selector(signUpButtonClicked), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 10),
            loginButton.leadingAnchor.constraint(equalTo: passwordField.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: passwordField.trailingAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func signUpButtonClicked(){
        guard let email = userNameField.text,
              let password = passwordField.text else { return }
        AuthManager.shared.createUser(email: email, password: password) { (success) in
            if success{
                self.dismiss(animated: true)
            }
        }
    }
    
    @objc func hideOrShowPassword(){
        passwordField.isSecureTextEntry = !passwordField.isSecureTextEntry
        if passwordField.isSecureTextEntry {
            button.setImage(SFSymbols.eyeSlash, for: .normal)
            
        }else{
            button.setImage(SFSymbols.eye, for: .normal)
        }
    }
}
