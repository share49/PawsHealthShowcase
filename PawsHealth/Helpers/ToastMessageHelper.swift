//
//  ToastMessageHelper.swift
//  Hoowie
//
//  Created by Roger Pintó Diaz on 10/29/19.
//  Copyright © 2019 Roger Pintó Diaz. All rights reserved.
//

import Foundation
import Toast

enum ToastMessage {
    
    /// Error messages
    case emptyEmail
    case invalidEmail
    case tryAgain
    case uploadImageError
    case userNotFound
    case fillAllTheFieldsToSave
    
    /// Other messages
    case resetPasswordSuccess
    case thanksForTheTip

    /// Login
    case invalidPassword
    case passwordDontMatch
    case registerSuccess

    /// Success
    case savedSuccessfully
    case feedbackSent
    
    var stringValue: String {
        switch self {
            /// Error messages
            case .emptyEmail:
                return ls.email_is_empty_etc()

            case .invalidEmail:
                return ls.provide_a_valid_email()

            case .tryAgain:
                return ls.oops_something_went_wrong_please_try_again()

            case .uploadImageError:
                return ls.oops_we_couldnt_upload_the_image()

            case .userNotFound:
                return ls.email_address_is_not_registered_etc(k.appName)

            case .fillAllTheFieldsToSave:
                return ls.fillAllTheFieldsToSave()

            /// Other messages
            case .resetPasswordSuccess:
                return ls.please_check_your_email_to_reset_your_password()

            case .thanksForTheTip:
                return ls.thanksForContributing()

            /// Login
            case .invalidPassword:
                return ls.password_must_be_etc()

            case .passwordDontMatch:
                return ls.passwords_dont_match_etc()

            case .registerSuccess:
                return ls.userCreatedSuccessfully()

            /// Success
            case .savedSuccessfully:
                return ls.savedSuccessfully()

            case .feedbackSent:
                return ls.thanksForSharingYourFeedbackWithUs()
        }
    }
}

final class ToastMessageHelper {
    
    static func showToast(_ toastMessage: ToastMessage, duration: TimeInterval = 2, position: ToastPosition = .center) {
        showToastWithMessage(toastMessage.stringValue, duration: duration, position: position)
    }
    
    static func showToastWithMessage(_ message: String, duration: TimeInterval = 2, position: ToastPosition = .center) {
        Utils.topViewController().view.makeToast(message, duration: duration, position: position)
    }
}
