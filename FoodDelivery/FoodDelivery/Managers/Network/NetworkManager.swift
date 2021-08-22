import Foundation
import Alamofire
import Firebase

struct NetworkManager{
    static let shared = NetworkManager()
    
    private init (){}
    
    let endpoint = ""
    
    func getData<T: Decodable>(with url: String, method: HTTPMethod,type: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void){
        
        let request = AF.request(endpoint + url, method: method)
        request.responseDecodable(of: type) { response in
            guard response.error == nil else {
                completion(.failure(.connectionError))
                return
            }
            
            guard let data = response.value else {
                completion(.failure(.connectionError))
                return
            }
            
            completion(.success(data))
        }
        
    }
    
    func getCategoriesFromFirebase(completion: @escaping ([RestaurantGenreModel]?) -> Void){
        let ref: DatabaseReference!
        ref = Database.database().reference()
        var categoryList: [RestaurantGenreModel] = []
        ref.child("Categories").getData { (err, snapshot) in
            if let error = err {
                print(error)
                completion(nil)
            }
            else if snapshot.exists() {
                guard let response = snapshot.value as? Dictionary<String, Dictionary<String, String>> else { return }
                for (key, value) in response{
                    categoryList.append(RestaurantGenreModel(name: key, image: value["imageLink"] ?? ""))
                }
                completion(categoryList)
            }
            else {
                print("No data available")
            }
        }
        
    }
    func getFirebase<T: Decodable>(entityName: String, type: T.Type, completion: @escaping (Result<[T], Error>) -> Void){
        let ref: DatabaseReference!
        ref = Database.database().reference()
    
        ref.child(entityName).getData { (err, snapshot) in
            guard err == nil else {
                completion(.failure(err!))
                return
            }
            let decoder = JSONDecoder()
            let jsonData =  try! JSONSerialization.data(withJSONObject: snapshot.value!, options: .prettyPrinted)
            let json = try! decoder.decode([T].self, from: jsonData)
            completion(.success(json))
        }
    }
    
    func getFirebaseWithChild<T: Decodable>(entityName: String, child: String, child2 :String, type: T.Type, completion: @escaping (Result<[T], Error>) -> Void){
        let ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child(entityName).child(child).child(child2).getData { (err, snapshot) in
            if snapshot.exists() {
               
                guard err == nil else {
                    completion(.failure(err!))
                    return
                }
                let decoder = JSONDecoder()
                guard let jsonData =  try? JSONSerialization.data(withJSONObject: snapshot.value!, options: .prettyPrinted) else { completion(.failure(err!)) ;return }
                guard let json = try? decoder.decode([T].self, from: jsonData) else { return }

                completion(.success(json))
            }else{
                completion(.failure(NetworkError.connectionError))
            }
            
        }
    }
    
    func getFirebaseUser<T: Decodable>(entityName: String, child: String, type: T.Type, completion: @escaping (Result<T, Error>) -> Void){
        let ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child(entityName).child(child).getData { (err, snapshot) in
            if snapshot.exists() {
               
                guard err == nil else {
                    completion(.failure(err!))
                    return
                }
                let decoder = JSONDecoder()
                guard let jsonData =  try? JSONSerialization.data(withJSONObject: snapshot.value!, options: .prettyPrinted) else { completion(.failure(err!)) ;return }
                guard let json = try? decoder.decode(T.self, from: jsonData) else { print("hey") ;return }

                completion(.success(json))
            }else{
                completion(.failure(NetworkError.connectionError))
            }
            
        }
    }
    
    
    func updateBasket(entityName: String, restaurant: RestaurantMenuModel){
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        guard let uuid = Auth.auth().currentUser?.uid else { return }
        NetworkManager.shared.getFirebaseWithChild(entityName: "Basket", child: uuid, child2: "items", type: RestaurantMenuModel.self) { (result) in
            switch result{
            case .success(let lists):
                ref.child("Basket").child(uuid).child("items").updateChildValues([ String(lists.count): ["fiyat": restaurant.cost,
                                                                                        "icerik": restaurant.desc,
                                                                                        "malzemeler": restaurant.material,
                                                                                        "id": String(lists.count),
                                                                                        "adet": restaurant.adet!,
                                                                                        "isDeleted": false,
                                                                                        "name": restaurant.name]])
            case .failure(let _):
                ref.child("Basket").child(uuid).child("items").updateChildValues([ "0": ["fiyat": restaurant.cost,
                                                                                        "icerik": restaurant.desc,
                                                                                        "malzemeler": restaurant.material,
                                                                                        "id": "0",
                                                                                        "adet": restaurant.adet!,
                                                                                        "isDeleted": false,
                                                                                        "name": restaurant.name]])
                
            }
        }
    }
    
    func updateUser(name: String, surname: String, cardNumber: String, expireDate: String, CCV: String){
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        guard let uuid = Auth.auth().currentUser?.uid else { return }
        ref.child("Users").child(uuid).updateChildValues(["name": name,
                                                        "surname": surname,
                                                        "cardNumber": cardNumber,
                                                        "expireDate": expireDate,
                                                        "CCV": CCV])
    }
    
    func updateAdres(title: String, adres: String, binaNo: String, kat: String, daire: String, tarif: String, completion: @escaping (Bool) -> Void){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        guard let uuid = Auth.auth().currentUser?.uid else { return }
        ref.child("Users").child(uuid).child("adress").updateChildValues(["title": title,
                                                          "adressDesc": adres,
                                                          "buildingNumber": binaNo,
                                                          "flat": kat,
                                                          "apartmentNumber": daire,
                                                          "description": tarif])
        completion(true)
        
    }
    
    func deleteFood(index: Int){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        guard let uuid = Auth.auth().currentUser?.uid else { return }
        ref.child("Basket").child(uuid).child("items").child(String(index)).updateChildValues(["isDeleted": true])
    }
}

