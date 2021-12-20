//
//  ViewController.swift
//  PawsHealth
//
//  Created by Pinto Diaz, Roger on 6/26/20.
//  Copyright © 2020 Hoowie. All rights reserved.
//

import FirebaseAuth
import StoreKit
import UIKit

final class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PetListener {

    // MARK: - IBOutlets
    @IBOutlet weak var ivLaunchScreen: UIImageView!
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties
    var isFirstLaunch = true
    var isDataFetched = false
    var pets = [Pet]()
    var chartView: ChartsView!

    // MARK: - Initializers
    static func create() -> UIViewController {
        let viewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MainVC")
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Paws Health"
        setupNavigationController()
        setupCharts()
        setupTableView()
        fetchData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        if Auth.auth().currentUser == nil {
            present(SignInViewController.create(), animated: true)
        } else {
            if !isDataFetched {
                fetchData()
            }

            performSplashAnimation()
        }

        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: true)
        }

        showTipViewController()
        requestReview()
    }

    private func setupNavigationController() {
        let navColor = UIColor.white
        navigationController?.navigationBar.barTintColor = R.color.pawHealthBlue()
        navigationController?.navigationBar.tintColor = navColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: navColor]
    }

    private func setupTableView() {
        tableView.register(UINib(nibName: "CatCell", bundle: nil), forCellReuseIdentifier: "CatCell")
        tableView.register(UINib(nibName: "AddCatCell", bundle: nil), forCellReuseIdentifier: "AddCatCell")
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func setupCharts() {
        chartView = ChartsView(frame: vContainer.frame)
        chartView.translatesAutoresizingMaskIntoConstraints = false

        vContainer.addSubview(chartView)
        chartView.leftAnchor.constraint(equalTo: vContainer.leftAnchor, constant: 10).isActive = true
        chartView.rightAnchor.constraint(equalTo: vContainer.rightAnchor, constant: -10).isActive = true
        chartView.topAnchor.constraint(equalTo: vContainer.topAnchor, constant: 0).isActive = true
        chartView.bottomAnchor.constraint(equalTo: vContainer.bottomAnchor, constant: 0).isActive = true
    }

    private func performSplashAnimation() {
        guard isFirstLaunch else { return }

        #if targetEnvironment(macCatalyst)
        sleep(1)
        #endif

        UIView.animate(withDuration: 0.3, animations: {
            self.ivLaunchScreen.transform = CGAffineTransform(scaleX: 4, y: 4)
            self.ivLaunchScreen.alpha = 0
        }, completion: { (onDone) in
            self.ivLaunchScreen.isHidden = true
            self.isFirstLaunch = false
        })
    }

    // MARK: - Support methods
    private func fetchData() {
        guard Auth.auth().currentUser != nil else { return }

        DataService.instance.getPets { (pets) in
            onMain {
                if !self.isDataFetched {
                    self.isDataFetched = true
                    self.pets = pets
                    self.chartView.setupLineChart(pets: pets)
                    self.tableView.reloadData()
                }
            }
        }
    }

    private func addPet() {
        guard let nvc = navigationController else {
            return
        }

        Navigator(nvc).navigate(to: .newPet(delegate: self))
    }

    private func hasTheUserTipped(onCompletion: @escaping (Bool) -> Void) {
        let userDefaults = UserDefaults.standard
        let userTipped = userDefaults.bool(forKey: k.userDefs.userTipped)

        if userTipped {
            onCompletion(true)
        } else {
            DataService.instance.hasUserTipped { (hasTipped) in
                onCompletion(hasTipped)
            }
        }
    }

    private func showTipViewController() {
        hasTheUserTipped { (hasTipped) in
            guard !hasTipped else {
                return
            }

            let userDefaults = UserDefaults.standard
            let showTipsKey = k.userDefs.shouldShowTipsView
            let shouldShowTipsView = userDefaults.bool(forKey: showTipsKey)

            guard shouldShowTipsView else {
                return
            }

            userDefaults.setValue(false, forKey: showTipsKey)

            self.present(TipsViewController.create(), animated: true)
        }
    }

    private func requestReview() {
        let numberOfTrackedWeights: Int = {
            var num: Int = 0
            pets.forEach { (pet) in
                num += pet.weight?.count ?? 0
            }
            return num
        }()

        let userDefaults = UserDefaults.standard
        let isReviewed = k.userDefs.reviewRequested
        let shouldShowReview = !userDefaults.bool(forKey: isReviewed)

        guard shouldShowReview && numberOfTrackedWeights > 7 else {
            return
        }

        SKStoreReviewController.requestReview()

        userDefaults.setValue(true, forKey: isReviewed)
    }

    // MARK: - onButton actions
    @IBAction func onAdd(_ sender: UIBarButtonItem) {
        addPet()
    }

    @IBAction func onFeedback(_ sender: UIBarButtonItem) {
        present(FeedbackViewController.create(), animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pets.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row

        if index == pets.count {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "AddCatCell", for: indexPath) as? AddCatCell {
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CatCell", for: indexPath) as? CatCell {
                cell.setup(with: pets[index])
                return cell
            }
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row

        if index == pets.count {
            addPet()
        } else {
            if let nvc = navigationController {
                Navigator(nvc).navigate(to: .petDetail(delegate: self, pet: pets[index]))
            }
        }
    }

    // MARK: - PetListener
    func onRefresh(pet: Pet?) {
        isDataFetched = false
        fetchData()
    }
}
