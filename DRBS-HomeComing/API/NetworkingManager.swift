import UIKit
import FirebaseFirestore
import KakaoSDKUser
import KakaoSDKAuth
import FirebaseAuth
import CoreLocation
import FirebaseStorage

// ⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️공식문서⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️
// https://firebase.google.com/docs/firestore/manage-data/add-data?hl=ko

class NetworkingManager {
    //MARK: - Singleton Pattern
    static let shared = NetworkingManager()
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    var housesRef: CollectionReference!
    private init() {
        
        
    }
    
    //MARK: - Auth
    /// - note: kakao Auth Create - 소셜 로그인 계정 생성
    func kakaoAuthCreate(kuser: KakaoSDKUser.User?, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let email = kuser?.kakaoAccount?.email,
              let id = kuser?.id else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Invalid user data"]))) /// 이메일 권한 누락 확인용.
            return
        }
        Auth.auth().createUser(withEmail: email, password: "\(id)") { _, error in
            if let error = error {
                print("FB : signup failed. \(error)")
                
                Auth.auth().signIn(withEmail: email, password: "\(id)") { _, error in
                    if let error = error {
                        print("FB : signin failed. \(error)")
                        completion(.failure(error))
                    } else {
                        print("FB : signin success")
                        completion(.success(true))
                        ///테스트
                        if let user = Auth.auth().currentUser {
                            print("FIRUser: \(user.uid)")
                        }
                    }
                }
            } else {
                print("FB : signup success")
                completion(.success(true))
                ///테스트
                if let user = Auth.auth().currentUser {
                    print("FIRUser: \(user.uid)")
                }
            }
        }
    }
    /// - note: Apple Auth Create
    /// - note: Auth Logout - Auth 로그아웃
    func authLogout() {
        let auth = Auth.auth()
        do {
            try auth.signOut()
        } catch let signOutError as NSError { /// 오류 잡기
            print("FB : Error signing out - %@", signOutError)
        }
    }
    
    /// - note: Auth Delete - Auth 회원탈퇴
    func authDelete() {
        if let auth = Auth.auth().currentUser {
            auth.delete { error in
                if let error = error {
                    print("FB : Error - ",error)
                } else {
                    print("FB : authDelete success")
                }
            }
        } else {
            print("FB : Error - 로그인 정보가 존재하지 않습니다")
        }
    }
    
    //MARK: - 체크리스트관련메서드
    //MARK: - Create
    func addHouses(houseModel: House, images: [UIImage], completion: @escaping (Bool) -> Void) {
        print("새로운 데이터 저장 시작")
        let documentRef = db.collection("Homes").document()
        let houseId = documentRef.documentID
        var imageUrls: [String] = []
        images.forEach {
            self.uploadImage(houseId: houseId, image: $0) { imageUrl in
                imageUrls.append(imageUrl)
                if imageUrls.count == images.count {
                    print("Storage에 사진이 다 저장되고 다운로드 URL반환완료")
                    print("다운로드 URL은 \(imageUrls)")
                    //Storage에 다 올라갔으면, 반환되어 imageUrls에 저장된 값의 갯수가 같을 것
                    let house = houseModel
                    house.houseId = houseId
                    house.사진 = imageUrls
                    guard let data = house.asDictionary else { return }
                    print("데이터 생성(딕셔너리형태로)완료")
                    //올린 값들을 넣어 house모델 완성 후 Dictionary 형태로 변환(서버에 올리기 위함)
                    DispatchQueue.global().async {
                        documentRef.setData(data) { error in
                            if let error {
                                print(error.localizedDescription)
                            } else {
                                print("데이터를 올리는데 성공했습니다.")
                                completion(true)
                                //올리는 데 성공하면 true를 반환
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    //MARK: - Read
    func fetchHousesWithCurrentUser(currentUser: String? ,completion: @escaping ([House]) -> Void) {
        guard let currentUserUID = currentUser else {
            // 현재 사용자 UID를 가져올 수 없으면 종료
            completion([])
            return
        }
        db.collection("Homes").whereField("uid", isEqualTo: currentUserUID).getDocuments { querySnapshot, error in
            //현재 유저와 같은 document만 가져옴
            if let error = error {
                print("Error fetching houses: \(error.localizedDescription)")
                completion([])
                return
            }
            guard let documents = querySnapshot?.documents else {
                completion([])
                return
            }
            let houses = documents.compactMap { document -> House? in
                let data = document.data()
                do {
                    let decoder = JSONDecoder()
                    let jsonData = try JSONSerialization.data(withJSONObject: data)
                    let house = try decoder.decode(House.self, from: jsonData)
                    return house
                } catch {
                    print("Error decoding house: \(error.localizedDescription)")
                    return nil
                }
            }
            completion(houses)
        }
    }
    
    
    
    //MARK: - Update
    func updateHouseInFirebase(houseModel: House, images: [UIImage], completion: @escaping (Bool) -> Void) {
        print("업데이트 실행됨")
        let house = houseModel
        guard let houseId = houseModel.houseId else { return }
        print("하우스 아이디는 \(houseId)")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        print("리스트 읽기 전")
        let listRef = Storage.storage().reference().child("\(uid)/\(houseId)")
        listRef.listAll { (result, error) in
            if let error = error {
                print("Error listing files: \(error.localizedDescription)")
                return
            }
            var stringImages: [String] = []
            guard let result = result else { return }
            for item in result.items {
                item.delete { error in
                    if let error = error {
                        print("Error deleting file: \(error.localizedDescription)")
                    } else {
                        DispatchQueue.global().async {
                            images.forEach {
                                self.uploadImage(houseId: houseId, image: $0) { imageUrl in
                                    stringImages.append(imageUrl)
                                }
                            }
                            house.사진 = stringImages
                            guard let data = house.asDictionary else { return }
                            self.db.collection("Homes").document(houseId).setData(data, merge: true) { error in
                                if let error = error {
                                    print("Error updating document: \(error.localizedDescription)")
                                } else {
                                    completion(true)
                                }
                            }
                        }
                    }
                }
            }
        }
    }


        
    

    func deleteOldFiles(houseId: String, completion: @escaping () -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        // 해당 경로의 파일 및 폴더를 삭제
        let deleteRef = storage.child("\(uid)/\(houseId)")
        let listRef = storage.child("\(uid)/\(houseId)")
        listRef.listAll { (result, error) in
            if let error = error {
                print("Error listing files: \(error.localizedDescription)")
                return
            }
            guard let result = result else { return }
            for item in result.items {
                item.delete { error in
                    if let error = error {
                        print("Error deleting file: \(error.localizedDescription)")
                    }
                }
            }
        }
        completion()
    }
  
    
    //MARK: - Delete
    func deleteHouse(houseId: String, completion: @escaping (Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let pathToDelete = "\(uid)/\(houseId)"
        let listRef = Storage.storage().reference().child("\(uid)/\(houseId)")
        listRef.listAll { (result, error) in
            if let error = error {
                print("Error listing files: \(error.localizedDescription)")
                return
            }
            guard let result = result else { return }
            for item in result.items {
                item.delete { error in
                    if let error = error { print("Error deleting file: \(error.localizedDescription)")
                    } else { print("File deleted successfully: \(item.name)") }
                }
            }
        }
        db.collection("Homes").document(houseId).delete { err in
            if let err = err {
                print("Error removing: \(err)")
                completion(false)
            }
            completion(true)
        }
    }
}


//MARK: - Extensions
extension NetworkingManager {
    func uploadImage(houseId: String, image: UIImage, completion: @escaping(String) -> Void) {
        //FireStore Storage의 uid->houseId 내부에 파일 저장
        //파일을 저장한 뒤 해당 파일의 DownloadURL을 Completion을 통해 반환
        guard let imageData = image.jpegData(compressionQuality: 0.75),
              let uid = Auth.auth().currentUser?.uid else { return }
        let filename = NSUUID().uuidString
        let ref = storage.child("/\(uid)/\(houseId)/\(filename)")
        DispatchQueue.global().async {
            ref.putData(imageData) { _, error in
                if let error = error {
                    print("DEBUG: Failed to upload image \(error.localizedDescription)")
                    return
                } else {
                    ref.downloadURL { url, error in
                        if let error = error {
                            print("DEBUG: Failed to make downloadURL \(error.localizedDescription)")
                        }
                        guard let imageUrl = url?.absoluteString else { return }
                        completion(imageUrl)
                    }
                }
            }
        }
        
    }
    
    func updateImage(houseId: String, image: UIImage, completion: @escaping(String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.75),
              let uid = Auth.auth().currentUser?.uid else { return }
       
        let filename = NSUUID().uuidString
        let ref = storage.child("/\(uid)/\(houseId)/\(filename)")
        ref.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("DEBUG: Failed to upload image \(error.localizedDescription)")
                return
            }
            ref.downloadURL { url, error in
                if let error = error {
                    print("DEBUG: Failed to make downloadURL \(error.localizedDescription)")
                }
                guard let imageUrl = url?.absoluteString else { return }
                completion(imageUrl)
            }
        }
    }
    func observeData() {
        //서버에 값이 변했는지 안변했는지 감시하는 관리자!
        
    }
}
