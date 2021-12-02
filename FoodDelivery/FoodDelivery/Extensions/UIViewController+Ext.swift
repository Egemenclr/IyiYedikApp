import UIKit
import RxSwift

extension UIViewController{
    func makeAlert(title: String, message: String) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        return alert
    }
    
    func returnCustomAlertOnMainThread(title: String, message: String, buttonTitle: String) -> AlertVC?{
        let alertVC = AlertVC(title: title, message: message, buttonTitle: buttonTitle)
        alertVC.modalPresentationStyle  = .overFullScreen
        alertVC.modalTransitionStyle    = .crossDissolve
        return alertVC
        
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showAlert(
        title: String? = "Uyarı",
        message: String? = "",
        positiveButtonTitle: String,
        negativeButtonTitle: String = "Vazgeç"
    ) -> Single<Bool> {
        return Single.create(subscribe: { [weak self] single -> Disposable in
            guard let self = self else { return Disposables.create() }
            
            let alertController = UIAlertController(title: title,
                                                    message: message,
                                                    preferredStyle: .alert
            )
            
            let okButtonAction = UIAlertAction(title: positiveButtonTitle,
                                               style: .default) { _ in
                single(.success(true))
            }
            alertController.addAction(okButtonAction)
            let cancelButtonAction = UIAlertAction(title: negativeButtonTitle,
                                                   style: .cancel) { _ in
                single(.success(false))
            }
            alertController.addAction(cancelButtonAction)
            
            self.present(alertController, animated: true, completion: nil)
            return Disposables.create {
                alertController.dismiss(animated: false, completion: nil)
            }
        })
    }
}

// MARK: - Rx + UIViewController
extension Reactive where Base: UIViewController {
    var showLoading: Binder<Bool> {
        Binder(base) { [weak base] _, isLoading in
            
        }
    }
}
