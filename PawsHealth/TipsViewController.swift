//
//  TipsViewController.swift
//  PawsHealth
//
//  Created by Pinto Diaz, Roger on 9/18/20.
//  Copyright © 2020 Hoowie. All rights reserved.
//

import StoreKit.SKProduct
import UIKit

final class TipsViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var btnSmallTip: UIButton!
    @IBOutlet weak var btnMediumTip: UIButton!
    @IBOutlet weak var btnBigTip: UIButton!
    @IBOutlet weak var btnNotNow: UIButton!

    // MARK: - Properties
    private let productIds = ["Credits_1", "Credits_2", "Credits_3"]
    private var fetcher = SKProductFetcher()
    private var skProducts = [SKProduct]()

    // MARK: - Public interface
    static func create() -> UIViewController {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TipsVC") as! TipsViewController
        viewController.modalPresentationStyle = .overFullScreen
        return viewController
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        addTapGestureRecognizerToHideKeyboardTappingOutsideIt()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)

        lblTitle.text = ls.enjoyingPawsHealth()
        lblSubtitle.text = ls.supportPawsHealthWithASmallTip()
        btnNotNow.setTitle(ls.notNow(), for: UIControl.State())

        let buttons = [btnSmallTip, btnMediumTip, btnBigTip]
        buttons.forEach { (button) in
            button?.setTitle(ls.contribute(""), for: UIControl.State())
            button?.titleLabel?.textAlignment = .center
            button?.roundedCorners(radius: 10)
        }

        setupContainerView()
        setupConfettiView()

        fetchAvailablePurchases()
    }

    deinit {
        MyLogD("Dealloc: \(self)")
    }

    // MARK: - UI methods
    private func setupContainerView() {
        vContainer.roundedCornersModalView()
        vContainer.mapPostShadow()
    }

    private func setupConfettiView() {
        let confettiView = ConfettiView(frame: view.frame)
        view.addSubview(confettiView)
        view.sendSubviewToBack(confettiView)
    }

    // MARK: - Purchase methods
    private func fetchAvailablePurchases() {
        skProducts.removeAll()

        fetcher.getProducts(Set(productIds)) { [unowned self] skProducts in
            onMain {
                self.skProducts = skProducts
                self.skProducts.forEach { (skProduct) in
                    let price = skProduct.localizedPrice

                    if skProduct.productIdentifier == productIds[0] {
                        btnSmallTip.setTitle(ls.contribute(price), for: UIControl.State())

                    } else if skProduct.productIdentifier == productIds[1] {
                        btnMediumTip.setTitle(ls.contribute(price), for: UIControl.State())

                    } else if skProduct.productIdentifier == productIds[2] {
                        btnBigTip.setTitle(ls.contribute(price), for: UIControl.State())
                    }
                }
            }
        }
    }

    private func fetchProductAndAttemptToPay(productId: String) {
        guard let product = skProducts.first(where: { $0.productIdentifier == productId }) else {
            return
        }

        let loadingView = ViewsHelper.addShowAndGetOpaqueLoadingView(to: view)

        PurchaseHelper.instance.purchaseProduct(product) { (success, error) in
            MyLogI("Credits: Get \(productId), purchase success: \(success)")

            if success {
                DataService.instance.setUserTipped()

                self.dismiss(animated: true) {
                    ToastMessageHelper.showToast(.thanksForTheTip)
                }

            } else { /// On error or when the user cancels the payment
                onMain {
                    loadingView.removeFromSuperview()
                }

                if let errorMessage = error?.localizedDescription {
                    ToastMessageHelper.showToastWithMessage(errorMessage)
                }
            }
        }
    }

    // MARK: - onButton actions
    @IBAction func onSmallPayTip(_ sender: UIButton) {
        fetchProductAndAttemptToPay(productId: productIds[0])
    }

    @IBAction func onMediumPayTip(_ sender: UIButton) {
        fetchProductAndAttemptToPay(productId: productIds[1])
    }

    @IBAction func onBigPayTip(_ sender: UIButton) {
        fetchProductAndAttemptToPay(productId: productIds[2])
    }

    @IBAction func onNotNow(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
