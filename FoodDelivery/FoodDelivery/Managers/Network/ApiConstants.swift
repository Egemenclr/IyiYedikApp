import Foundation


public enum NetworkError: Error {
    
    public enum ErrorMessageConst {
        static let defaultErrorMessage = "Geçici bir sorun oldu"
        static let defaultConnectionErrorMessage = "internet baglantısı yok"
    }
    
    case operationFailed
    case connectionError
    case serviceError(ServiceErrorr)
    case error(Error)
    
    public var message: String? {
        switch self {
        case .operationFailed:
            return ErrorMessageConst.defaultErrorMessage
        case .connectionError:
            return ErrorMessageConst.defaultConnectionErrorMessage
        case .serviceError(let err):
            return err.errorKey
        case .error(_):
            return ErrorMessageConst.defaultErrorMessage
        }
    }
}

public struct ServiceErrorr: Codable {
    var errorKey: String?
    var title: String?
    var status: Int?
    var path: String?
}
