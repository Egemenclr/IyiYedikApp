import UIKit
import RxSwift
import RxCocoa

class LoadingView: UIView {
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var blurView: UIVisualEffectView = UIVisualEffectView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        startLoading()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.frame = UIWindow(frame: UIScreen.main.bounds).frame
        activityIndicator.center = blurView.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        blurView.contentView.addSubview(activityIndicator)
    }
    
    func startLoading() {
        UIApplication.shared.windows.first?.addSubview(blurView)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        blurView.removeFromSuperview()
        activityIndicator.stopAnimating()
    }
    
    func showLoadingView() -> Single<Void> {
        return Single.create { [weak self] single in
            guard let self = self else { return Disposables.create {} }
            self.startLoading()
            return Disposables.create()
        }
    }
    
    func hideLoadingView() -> Single<Void> {
        return Single.create { [weak self] single in
            guard let self = self else { return Disposables.create {} }
            self.hideLoading()
            return Disposables.create()
        }
    }
}


extension Reactive where Base == LoadingView {
    var hideAnimate: Binder<Bool> {
        Binder(base) { target, message in
            print("burda")
            target.hideLoadingView()
                .asObservable()
                .subscribe()
                .disposed(by: DisposeBag())
        }
    }
}
