import UIKit
import GoogleSignIn
import RxSwift
import RxCocoa

class LoginVC: UIViewController {
    fileprivate let bag = DisposeBag()
    enum Theme{
        case light, dark
    }
    
    let imageView = UIImageView()
    let epostaSection   = CustomLoginTextFieldView()
    let passwordSection = CustomLoginTextFieldView()
    let signInButton    = CustomButton(backgroundColor: .orange, title: "GİRİŞ YAP")
    let button = UIButton(type: .custom)
    
    
    let googleButton = CustomButton()
    
    
    let divider = UIView()
    
    
    let textLabel = CustomSecondaryLabel(fontSize: 14, textAlignment: .center)
    let registerLabel = CustomSecondaryLabel(fontSize: 14, textAlignment: .left)
    let forgotPasswordLabel = CustomSecondaryLabel(fontSize: 14, textAlignment: .left)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureUI()
        configureLabels()
        
        let inputs = LoginViewModelInput(
            username: epostaSection.textField.rx.text.orEmpty.asObservable(),
            password: passwordSection.textField.rx.text.orEmpty.asObservable(),
            loginButtonTapped: rx.loginButtonTapped.asObservable(),
            disposeBag: bag
        )
        
        let viewModel = LoginViewModel(inputs)
        let outputs = viewModel.outputs(inputs)
        
        outputs
            .showSiparisVC
            .skip(1)
            .drive(rx.showSiparisVC)
            .disposed(by: bag)
            
        outputs
            .showError
            .drive(rx.showError)
            .disposed(by: bag)
        
        outputs
            .isLoginValid
            .drive(signInButton.rx.isEnabled)
            .disposed(by: bag)
       
    }
    
    
    
    private func configureUI(){
        configureImageView()
        configureEpostaSection()
        configurePasswordSection()
        configureSignInButton()
        
        configureGoogleButton()
        
        configureStackView()
        
        divider.layer.borderWidth = 1
        divider.layer.borderColor = UIColor.lightGray.cgColor
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
    
    private func configureEpostaSection(){
        view.addSubview(epostaSection)
        epostaSection.set(headerText: "E-Posta", placeHolder: "your@mail.com")
        
        NSLayoutConstraint.activate([
            epostaSection.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
            epostaSection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            epostaSection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            epostaSection.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func configurePasswordSection(){
        view.addSubview(passwordSection)
        passwordSection.set(headerText: "Şifre", placeHolder: "*******")
        passwordSection.textField.rightViewMode = .always
        passwordSection.textField.isSecureTextEntry = true
        
        button.setImage(SFSymbols.eyeSlash, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 10)
        button.frame = CGRect(x: 5, y: CGFloat(5), width: 10, height: 10)
        button.tintColor = .lightGray
        button.addTarget(self, action: #selector(hideOrShowPassword), for: .touchUpInside)
        passwordSection.textField.rightView = button
        
        NSLayoutConstraint.activate([
            passwordSection.topAnchor.constraint(equalTo: epostaSection.bottomAnchor, constant: 10),
            passwordSection.leadingAnchor.constraint(equalTo: epostaSection.leadingAnchor),
            passwordSection.trailingAnchor.constraint(equalTo: epostaSection.trailingAnchor),
            passwordSection.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    @objc func hideOrShowPassword(){
        passwordSection.textField.isSecureTextEntry = !passwordSection.textField.isSecureTextEntry
        if passwordSection.textField.isSecureTextEntry {
            button.setImage(SFSymbols.eyeSlash, for: .normal)
        }else{
            button.setImage(SFSymbols.eye, for: .normal)
        }
    }
    
    private func configureSignInButton(){
        view.addSubview(signInButton)
        view.addSubview(divider)
        
        divider.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            signInButton.topAnchor.constraint(equalTo: passwordSection.bottomAnchor, constant: 20),
            signInButton.leadingAnchor.constraint(equalTo: passwordSection.leadingAnchor, constant: 10),
            signInButton.trailingAnchor.constraint(equalTo: passwordSection.trailingAnchor, constant: -10),
            signInButton.heightAnchor.constraint(equalToConstant: 50),
            
            divider.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 15),
            divider.leadingAnchor.constraint(equalTo: signInButton.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: signInButton.trailingAnchor),
            divider.heightAnchor.constraint(equalToConstant: 2)
        ])
    }


    private func configureGoogleButton(){
        view.addSubview(googleButton)
        
        
        googleButton.setIcon(with: "google.png", title: " Google ile Devam Et")
        
        googleButton.backgroundColor = .systemRed
        googleButton.addTarget(self, action: #selector(googleSignIn), for: .touchUpInside)
        //googleButton.setTextColor(color: .label)
        
        NSLayoutConstraint.activate([
            googleButton.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 20),
            googleButton.leadingAnchor.constraint(equalTo: signInButton.leadingAnchor),
            googleButton.trailingAnchor.constraint(equalTo: signInButton.trailingAnchor),
            googleButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    @objc func googleSignIn(){
        
        let signInConfig = GIDConfiguration.init(clientID: "99265866548-hkmqt3teb8erls33ip9jq40h9411rvlj.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            
            // If sign in succeeded, display the app's main content View.
        }
        
    }
    
    private func configureStackView(){
        
        let stackView = UIStackView(arrangedSubviews: [textLabel, registerLabel, forgotPasswordLabel])
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: googleButton.bottomAnchor, constant: 30),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            stackView.heightAnchor.constraint(equalToConstant: 15)
        ])
    }
    
    private func configureLabels(){
        textLabel.text = "Henüz üye değil misin?"
        
        registerLabel.text = "Kayıt Ol"
        registerLabel.textStyle(font: Fonts.helvetica_bold!)
        registerLabel.isUserInteractionEnabled = true
        registerLabel.tag = 0
        registerLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(labelClicked(_:))))
        
        forgotPasswordLabel.text = "Şifremi Unuttum"
        forgotPasswordLabel.textStyle(font: Fonts.helvetica_bold!)
        forgotPasswordLabel.isUserInteractionEnabled = true
        forgotPasswordLabel.tag = 1
        forgotPasswordLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(labelClicked(_:))))
        
    }
    
    @objc func labelClicked(_ sender: UITapGestureRecognizer){
        switch sender.view?.tag{
        case 0:
            self.present(RegisterVC(), animated: true)
        case 1:
            // pop-up aç email iste, email gönder.
            break
        default:
            break
        }
    }
    
}

extension Reactive where Base == LoginVC {
    var loginButtonTapped: ControlEvent<Void> {
        base.signInButton.rx.tap
    }
    
    var googleButtonTapped: ControlEvent<Void> {
        base.googleButton.rx.tap
    }
    
    var showSiparisVC: Binder<Bool> {
        Binder(base) { target, success in
            if success {
                UserDefaults.standard.set(true, forKey: "userLoggedIn")
                let tabbar = CustomTabbarController()
                tabbar.modalPresentationStyle = .fullScreen
                target.self.present(tabbar, animated: true)
            }
        }
    }
    
    var showError: Binder<String> {
        Binder(base) { target, errorMessage in
            target.showAlert(
                title: ErrorMessage.failHeader,
                message: errorMessage,
                positiveButtonTitle: ButtonConstants.ok,
                negativeButtonTitle: ButtonConstants.cancel
            )
                .subscribe()
                .disposed(by: target.bag)
        }
    }
}

private enum ErrorMessage {
    static let failHeader       = "Hata"
    static let emailFailed      = "Email adresiniz sistemimiz ile eşleşmiyor."
    static let passwordFailed   = "Şifreniz doğru değil"
}

private enum ButtonConstants {
    static let ok = "Tamam"
    static let cancel = "İptal"
}
