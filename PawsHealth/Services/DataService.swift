//
//  DataService.swift
//  PawsHealth
//
//  Created by Pinto Diaz, Roger on 6/26/20.
//  Copyright © 2020 Hoowie. All rights reserved.
//

import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import UIKit

final class DataService {

    // MARK: - Properties
    static let instance = DataService()

    private var _REF_BASE = Firestore.firestore()
    private var _REF_STORAGE = Storage.storage().reference()

    private var REF_BASE: Firestore {
        let settings = _REF_BASE.settings
        _REF_BASE.settings = settings

        return _REF_BASE
    }

    private var REF_STORAGE: StorageReference {
        _REF_STORAGE
    }

    private var userReference: DocumentReference? {
        guard let currentUser = currentUserId else {
            MyLogE("userReference: User can't be nil!")
            return nil
        }
        return REF_BASE.collection("users").document(currentUser)
    }

    private var feedbackReference: CollectionReference {
        REF_BASE.collection("feedback")
    }

    private var currentUserId: String? {
        Auth.auth().currentUser?.uid
    }

    private var _user: User?

    // MARK: - User Data
    func createDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_BASE.collection("users").document(uid).setData(userData)
    }

    func uploadPetPicture(petId: String, photo: UIImage, onCompletion: @escaping () -> ()) {
        guard let currentUser = currentUserId else { return }

        let image = Utils.resizeImage(image: photo, maxSide: 400).jpegData(compressionQuality: 0.7)
        let imageRef = DataService.instance.REF_STORAGE.child("images").child(currentUser).child(UUID().uuidString)

        imageRef.putData(image!, metadata: nil) { (metadata, error) in
            if let error = error {
                self.showFirestoreUploadPhotoError(error: error)
            } else {
                MyLogD("Firestore: UploadPhoto: Image uploaded successfully")
                imageRef.downloadURL(completion: { (url, error) in
                    guard let url = url else {
                        self.showFirestoreUploadPhotoError(error: error)
                        return
                    }

                    MyLogD("Firestore: Image url downloaded successfully")

                    self.updatePetProfileImage(petId: petId, url: url.absoluteString) {
                        onCompletion()
                    }
                })
            }
        }
    }

    private func updatePetProfileImage(petId: String, url: String, onCompletion: @escaping () -> ()) {
        userReference?.collection("pets").document(petId).updateData(["imageUrl": url], completion: { (err) in
            if let error = err {
                MyLogE("Update pet \(petId) picture: \(error)")
                return
            }

            onCompletion()
        })
    }

    func uploadPetPicture(photo: UIImage, onCompletion: @escaping (String) -> ()) {
        guard let currentUser = currentUserId else { return }

        let image = Utils.resizeImage(image: photo, maxSide: 400).jpegData(compressionQuality: 0.7)
        let imageRef = DataService.instance.REF_STORAGE.child("images").child(currentUser).child(UUID().uuidString)

        imageRef.putData(image!, metadata: nil) { (metadata, error) in
            if let error = error {
                self.showFirestoreUploadPhotoError(error: error)
            } else {
                MyLogD("Firestore: UploadPhoto: Image uploaded successfully")
                imageRef.downloadURL(completion: { (url, error) in
                    guard let url = url else {
                        self.showFirestoreUploadPhotoError(error: error)
                        return
                    }

                    MyLogD("Firestore: Image url downloaded successfully")
                    onCompletion(url.absoluteString)
                })
            }
        }
    }

    private func showFirestoreUploadPhotoError(error: Error?) {
        MyLogE("Firestore: UploadPhoto: \(error.debugDescription)")
        Utils.topViewController().showOkAlertWithMessage(title: ls.oops_we_couldnt_upload_the_image())
    }

    func sendFeedback(_ text: String, onCompletion: @escaping () -> Void) {
        let feedback: Dictionary<String, Any> = ["Feedback": text, "Date": Date(), "User": currentUserId]
        feedbackReference.document().setData(feedback, completion: { (error) in
            if let error = error {
                MyLogE("Firestore: sendFeedback: \(error.localizedDescription)")
                ToastMessageHelper.showToastWithMessage(error.localizedDescription)
                return
            }

            onCompletion()
        })
    }

    // MARK: - Tips

    func setUserTipped() {
        userReference?.updateData([k.firebase.tipped: true])
    }

    func hasUserTipped(onCompletion: @escaping (Bool) -> Void) {
        userReference?.getDocument(completion: { (snapshot, err) in
            if let dict = snapshot?.data(), let hasTipped = dict[k.firebase.tipped] as? Bool {
                onCompletion(hasTipped)
            } else {
                onCompletion(false)
            }
        })
    }

    // MARK: - Pet

    func createNewPet(pet: Pet, onCompletion: @escaping (String) -> Void) {
        let document = userReference?.collection("pets").document()
        document?.setData(pet.toJSON(), completion: { (err) in
            if let error = err {
                MyLogE("CreateNewPet: \(error)")
                return
            }

            onCompletion(document!.documentID)
        })
    }

    func getPets(onCompletion: @escaping ([Pet]) -> Void) {
        userReference?.collection("pets").getDocuments(completion: { (querySnapshot, error) in
            guard let snapshot = querySnapshot else { return }

            var pets = [Pet]()

            for document in snapshot.documents {
                do {
                    var pet: Pet = try document.decoded()
                    pet.id = document.documentID
                    pets.append(pet)
                } catch {
                    MyLogE("Couldn't decode pets")
                }
            }

            onCompletion(pets)
        })
    }

    func trackWeight(pet: Pet, onCompletion: @escaping () -> Void) {
        userReference?.collection("pets").document(pet.id).updateData(pet.toJSON(), completion: { (err) in
            if let error = err {
                MyLogE("TrackWeight: \(error)")
                return
            }

            onCompletion()
        })
    }

    func savePetDetail(pet: Pet, onCompletion: @escaping () -> Void) {
        userReference?.collection("pets").document(pet.id).updateData(pet.basicPropertiesToJSON(), completion: { (err) in
            if let error = err {
                MyLogE("savePetDetail: \(error)")
                return
            }

            onCompletion()
        })
    }

    func deletePet(pet: Pet, onCompletion: @escaping () -> Void) {
        userReference?.collection("pets").document(pet.id).delete(completion: { (error) in
            if let error = error {
                MyLogE("deletePet: \(error)")
                return
            }

            onCompletion()
        })
    }
}
