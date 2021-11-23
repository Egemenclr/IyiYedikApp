import UIKit

class OfflineVC: UIViewController {

    let offlineView = EmptyViewState(image: UIImage(systemName: "wifi.slash")!,
                                     messageText: "İnternet bağlantın yok gibi",
                                     messageDesc: "Az ye de internet al :)")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        offlineView.bounds = view.bounds
        view = offlineView
    }

}
