//
//  PetDetailViewController.swift
//  PawsHealth
//
//  Created by Pinto Diaz, Roger on 7/1/20.
//  Copyright © 2020 Hoowie. All rights reserved.
//

import Photos
import UIKit

final class PetDetailViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource, PetListener {

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var hStack: UIStackView!

    // MARK: - Properties
    weak private var delegate: PetListener?
    private var pet: Pet!
    private var hasImageChanges = false

    // MARK: - Public interface
    static func create(delegate: PetListener, pet: Pet) -> UIViewController {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PetDetailVC") as! PetDetailViewController
        viewController.delegate = delegate
        viewController.pet = pet
        return viewController
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        addTapGestureRecognizerToHideKeyboardTappingOutsideIt()

        title = pet.name
        tfName.text = pet.name
        lblWeight.text = pet.formattedWeight
        btnSave.setTitle(ls.save(), for: UIControl.State())
        btnSave.circularView()

        setupProfileImageView()
        setupTableView()
        setupStackView()

        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(onAddNewRecord)),
            UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(onDelete))
        ]
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: true)
        }
    }

    deinit {
        MyLogD("Dealloc: \(self)")
    }

    // MARK: - UI methods
    private func setupTableView() {
        tableView.register(UINib(nibName: "CatCell", bundle: nil), forCellReuseIdentifier: "CatCell")
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func setupStackView() {
        hStack.distribution = .fillEqually
        let stackHeight = hStack.bounds.height

        for color in Colors.allCases {
            let vColor = UIView(frame: CGRect(x: 0, y: 0, width: stackHeight, height: stackHeight))
            vColor.circularView()
            vColor.backgroundColor = Colors.getColor(from: color.rawValue)
            vColor.isUserInteractionEnabled = true
            vColor.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSelectColor)))

            setColorViewBorder(view: vColor, colorName: color.rawValue)
            hStack.addArrangedSubview(vColor)
        }
    }

    private func setColorViewBorder(view: UIView, colorName: String) {
        if let petColorName = pet.colorName, petColorName == colorName {
            view.border(width: 2, color: .label)
        }
    }

    private func setupProfileImageView() {
        if let imageUrl = pet.imageUrl {
            ivProfile.circularView()
            ivProfile.contentMode = .scaleAspectFill
            ImageLoadHelper.load(imageUrl, in: ivProfile)
        }
        ivProfile.isUserInteractionEnabled = true
        ivProfile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(updateProfilePicture)))
    }

    // MARK: - onButton actions
    @IBAction func onSave(_ sender: UIButton) {
        if hasImageChanges, let image = ivProfile.image {
            DataService.instance.uploadPetPicture(photo: image) { (url) in
                self.pet.imageUrl = url

                DataService.instance.savePetDetail(pet: self.pet) {
                    ToastMessageHelper.showToast(.savedSuccessfully)
                    self.delegate?.onRefresh(pet: self.pet)
                }
            }
        } else {
            DataService.instance.savePetDetail(pet: self.pet) {
                ToastMessageHelper.showToast(.savedSuccessfully)
                self.delegate?.onRefresh(pet: self.pet)
            }
        }
    }

    @objc private func onSelectColor(sender: UITapGestureRecognizer) {
        if let vColor = sender.view, let selectedColor = vColor.backgroundColor {
            let colorName = Colors.getString(from: selectedColor)

            if !colorName.isEmpty {
                pet.colorName = colorName
                hStack.subviews.forEach { $0.border(width: 0, color: .label) }
                setColorViewBorder(view: vColor, colorName: colorName)
            }
        }
    }

    @objc private func onAddNewRecord() {
        Navigator(navigationController!).navigate(to: .weightDetail(delegate: self, pet: pet, index: nil))
    }

    @objc private func onDelete() {
        let alert = UIAlertController(title: nil, message: ls.areYouSureYouWantToDeleteIt(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: ls.cancel(), style: .cancel))
        alert.addAction(UIAlertAction(title: ls.delete(), style: .destructive, handler: { _ in
            DataService.instance.deletePet(pet: self.pet) {
                onMain {
                    self.navigationController?.popViewController(animated: true)
                    self.delegate?.onRefresh(pet: nil)
                }
            }
        }))

        present(alert, animated: true, completion: nil)
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = EditProfileHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 75))
        headerView.setupView(title: ls.weightRecord())
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        65
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pet.sortedWeights.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CatCell", for: indexPath) as? CatCell {
            cell.setupWeightCell(with: pet.sortedWeights[indexPath.row])
            return cell
        }

        return UITableViewCell()
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Navigator(navigationController!).navigate(to: .weightDetail(delegate: self, pet: pet, index: indexPath.row))
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let selectedWeight = pet.sortedWeights[indexPath.row]
            pet.weight?.removeAll(where: { $0 == selectedWeight })

            DataService.instance.trackWeight(pet: pet) {
                onMain {
                    self.onRefresh(pet: self.pet)
                    self.tableView.reloadData()
                }
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
            self.ivProfile.image = image
            self.hasImageChanges = true
        }
    }

    // MARK: - PetListener
    func onRefresh(pet: Pet?) {
        self.pet = pet
        tableView.reloadData()
        delegate?.onRefresh(pet: pet)
    }
}
