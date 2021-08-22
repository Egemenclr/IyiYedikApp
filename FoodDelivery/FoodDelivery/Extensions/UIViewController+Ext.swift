import UIKit

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
}
