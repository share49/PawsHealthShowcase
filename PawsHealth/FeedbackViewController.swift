//
//  FeedbackViewController.swift
//  PawsHealth
//
//  Created by Pinto Diaz, Roger on 11/7/20.
//  Copyright © 2020 Hoowie. All rights reserved.
//

import UIKit

final class FeedbackViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tfFeedback: UITextField!
    @IBOutlet weak var btnSend: UIButton!

    // MARK: - Public interface
    static func create() -> UIViewController {
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedbackVC") as! FeedbackViewController
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    // MARK: - UI methods
    private func setupView() {
        lblTitle.text = ls.shareYourFeedbackWithUs()
        tfFeedback.placeholder = ls.tellUsWhatYouThink()
        btnSend.setTitle(ls.send(), for: UIControl.State())
        btnSend.circularView()
    }

    // MARK: - onButton actions
    @IBAction func onSend(_ sender: UIButton) {
        guard let text = tfFeedback.text else {
            return
        }

        DataService.instance.sendFeedback(text) {
            onMain {
                self.dismiss(animated: true) {
                    ToastMessageHelper.showToast(.feedbackSent)
                }
            }
        }
    }
    
    @IBAction func onClose(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
