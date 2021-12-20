//
//  NewPetViewController.swift
//  PawsHealth
//
//  Created by Pinto Diaz, Roger on 7/1/20.
//  Copyright © 2020 Hoowie. All rights reserved.
//

import Photos
import UIKit

final class NewPetViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var btnSave: UIButton!

    // MARK: - Properties
    private weak var delegate: PetListener?
    private var hasImageChanges = false

    // MARK: - Public interface
    static func create(delegate: PetListener) -> UIViewController {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewPetVC") as! NewPetViewController
        viewController.delegate = delegate
        return viewController
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = ls.newPawMember()

        ivProfile.isUserInteractionEnabled = true
        ivProfile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(updateProfilePicture)))

        vContainer.border(width: 2, color: .darkGray)
        vContainer.circularView()

        btnSave.setTitle(ls.save(), for: UIControl.State())
        btnSave.circularView()

        lblName.text = ls.name()

        addTapGestureRecognizerToHideKeyboardTappingOutsideIt()
    }

    // MARK: - UI methods
    private func dismissView(pet: Pet) {
        onMain {
            self.navigationController?.popViewController(animated: true)
            self.delegate?.onRefresh(pet: pet)
        }
    }

    // MARK: - onButton actions
    @IBAction func onSave(_ sender: Any) {
        guard let name = tfName.text, !name.isEmpty else {
            ToastMessageHelper.showToast(.fillAllTheFieldsToSave)
            return
        }

        let pet = Pet(id: nil, imageUrl: nil, name: name, weight: nil)
        DataService.instance.createNewPet(pet: pet) { (petId) in
            if self.hasImageChanges, let image = self.ivProfile.image {
                DataService.instance.uploadPetPicture(petId: petId, photo: image, onCompletion: {
                    self.dismissView(pet: pet)
                })
            } else {
                self.dismissView(pet: pet)
            }
        }
    }

    // MARK: - UIImagePickerController
    @objc private func updateProfilePicture() {
        if checkCameraRollPermission() {
            onMain {
                let picker = UIImagePickerController()
                picker.delegate = self
                self.present(picker, animated: true)
            }
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        MyLogI("Image Picker Cancelled")
        dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true) {
            if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                self.setTempProfileImage(possibleImage)
            } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self.setTempProfileImage(possibleImage)
            }
        }
    }

    private func checkCameraRollPermission() -> Bool {
        switch PHPhotoLibrary.authorizationStatus() {
            case .authorized:
                return true
            case .denied:
                showCameraRollAccessAlert()
                return false
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { (newStatus) in
                    if newStatus == PHAuthorizationStatus.authorized {
                        self.updateProfilePicture()
                    } else {
                        self.showCameraRollAccessAlert()
                    }
                }
                return false
            default:
                return PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized
        }
    }

    private func showCameraRollAccessAlert() {
        onMain {
            self.showGoToSettingsAlertWithMessage(ls.cameraroll_permission_message(k.appName))
        }
    }

    private func setTempProfileImage(_ image: UIImage) {
        onMain {
            self.vContainer.border(width: 0, color: .clear)
            self.ivProfile.circularView()
            self.ivProfile.contentMode = .scaleAspectFill
            self.ivProfile.image = image
            self.hasImageChanges = true
        }
    }
}
