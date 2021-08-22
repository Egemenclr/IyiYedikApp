import Foundation
import FirebaseAuth


class AuthManager{
    static let shared = AuthManager()
    
    private init() {}
    
    func createUser(email: String, password: String, completion: @escaping (Bool) -> Void){
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            if err == nil {
                completion(true)
                return
            }else{
                completion(false)
                return
            }
        }
    }
    func logIn(_ email: String, _ password: String, completion: @escaping (Bool) -> Void){
        Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
            if (err == nil){
                completion(true)
                return
            }else {
                completion(false)
                return
            }
        }
    }
    
    func logOut(completion: (Bool) -> Void){
        do{
            try Auth.auth().signOut()
            UserDefaults.standard.setValue(false, forKey: "userLoggedIn")
            completion(true)
            return
        }catch{
            print(error)
            completion(false)
            return
        }
    }
    
    func getUUID()-> String{
        guard let uuid = Auth.auth().currentUser?.uid else { return "" }
        return uuid
    }
}
