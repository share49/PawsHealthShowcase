//
//  TrackWeightViewController.swift
//  PawsHealth
//
//  Created by Pinto Diaz, Roger on 7/1/20.
//  Copyright © 2020 Hoowie. All rights reserved.
//

import UIKit

protocol PetListener: AnyObject {
    func onRefresh(pet: Pet?)
}

final class TrackWeightViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnSave: UIButton!

    // MARK: - Properties
    private let offsetExtraPadding: CGFloat = 20
    private var pet: Pet!
    private var index: Int?
    weak private var delegate: PetListener?

    // MARK: - Public interface
    static func create(delegate: PetListener, pet: Pet, index: Int?) -> UIViewController {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewTrackVC") as! TrackWeightViewController
        viewController.delegate = delegate
        viewController.pet = pet
        viewController.index = index
        return viewController
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = ls.trackWeight()
        setupTableView()
        btnSave.circularView()
        btnSave.setTitle(ls.save(), for: UIControl.State())
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        MyLogD("Dealloc: \(self)")
    }

    // MARK: - UI methods
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FillCell", bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.fillCell.identifier)
        tableView.register(UINib(nibName: "DatePickerCell", bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.datePickerCell.identifier)
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor(named: "pawHealthBlue")?.withAlphaComponent(0.7)
        tableView.keyboardDismissMode = .onDrag
    }

    // MARK: - Support methods
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + offsetExtraPadding, right: 0)
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        if (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue != nil {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }

    private func setShouldShowTipsView() {
        guard let weightsCount = pet.weight?.count, (weightsCount % 5) == 0 else {
            return
        }

        UserDefaults.standard.setValue(true, forKey: k.userDefs.shouldShowTipsView)
    }

    // MARK: - onButton actions
    @IBAction func onSave(_ sender: Any) {
        var weight = ""
        var meal = ""
        var mealWeight = ""
        var date = ""

        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? FillCell, let text = cell.textField.text {
            weight = FormatterHelper.string(fromStringNumber: text)
        }
        if let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? FillCell, let text = cell.textField.text {
            meal = text
        }
        if let cell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? FillCell, let text = cell.textField.text {
            if text.isEmpty {
                mealWeight = "0"
            } else {
                mealWeight = FormatterHelper.string(fromStringNumber: text)
            }
        }
        if let cell = tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? DatePickerCell {
            date = FormatterHelper.getDataBaseStringDate(from: cell.datePicker.date)
        }

        guard !weight.isEmpty, !meal.isEmpty, !mealWeight.isEmpty, !date.isEmpty else {
            ToastMessageHelper.showToast(.fillAllTheFieldsToSave)
            return
        }

        let petWeight = PetWeight(date: date, weight: weight, meal: meal, mealWeight: mealWeight)

        if pet.weight == nil {
            pet.weight = [petWeight]
        } else {
            if !pet.weight!.isEmpty {
                if let index = index {
                    var sortedWeights = pet.sortedWeights
                    sortedWeights[index] = petWeight
                    pet.weight = sortedWeights
                } else {
                    pet.weight!.append(petWeight)
                }
            }
        }

        DataService.instance.trackWeight(pet: pet) {
            onMain {
                self.setShouldShowTipsView()
                self.navigationController?.popViewController(animated: true)
                self.delegate?.onRefresh(pet: self.pet)
            }
        }
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if #available(iOS 14.0, *) {
            return indexPath.row == 3 ? 95 : 75
        } else {
            return indexPath.row == 3 ? 160 : 75
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sortedWeights = pet.sortedWeights
        let weight = index != nil ? sortedWeights[index!] : nil

        if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.datePickerCell.identifier, for: indexPath) as! DatePickerCell
            cell.setup(stringDate: weight?.date)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.fillCell.identifier, for: indexPath) as! FillCell
            cell.setup(indexPath: indexPath, weight: weight, lastMeal: sortedWeights.first?.meal ?? "")
            return cell
        }
    }
}
