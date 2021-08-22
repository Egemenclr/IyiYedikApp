import Foundation
import Alamofire

struct Connectivity{
    
    static let sharedInstance = NetworkReachabilityManager()!
    
    
    static var isConnectedToInternet:Bool {
        // startListening func var.
        return self.sharedInstance.isReachable
    }
}

