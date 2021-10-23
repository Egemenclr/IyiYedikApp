import UIKit
import Alamofire
import RxSwift

struct Connectivity{
    
    static let sharedInstance = NetworkReachabilityManager()!
    
    static var isConnectedToInternet: Bool {
        return self.sharedInstance.isReachable
    }
    
    static var isStillConnecting: Single<Bool> = {
        return Single.create { single in
            let disposable = Disposables.create()
            if Connectivity.isConnectedToInternet {
                single(.success(true))
            } else {
                single(.failure(NetworkError.connectionError))
            }
            
            return disposable
        }
    }()
}

struct MockDatas{
    func returnViewControllers(width: CGFloat) -> [UIViewController]{
        let width = width
        var controllers = [UIViewController]()
        let viewC1 = UIViewController()
        let viewC2 = UIViewController()
        let viewC3 = UIViewController()
        
        let imageView = UIImageView(image: UIImage(named: "dominos"))
        viewC1.view.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: width, height: 200)
        imageView.contentMode = .scaleAspectFit
        
        let imageView2 = UIImageView(image: UIImage(named: "burgerking"))
        viewC2.view.addSubview(imageView2)
        imageView2.frame = CGRect(x: 0, y: 0, width: width, height: 200)
        imageView2.contentMode = .scaleAspectFit
        
        let imageView3 = UIImageView(image: UIImage(named: "kfc"))
        viewC3.view.addSubview(imageView3)
        imageView3.frame = CGRect(x: 0, y: 0, width: width, height: 200)
        imageView3.contentMode = .scaleAspectFit
    
        
        controllers.append(viewC1)
        controllers.append(viewC2)
        controllers.append(viewC3)
        
        return controllers
    }
    
}

