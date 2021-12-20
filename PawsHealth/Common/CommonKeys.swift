//
//  CommonKeys.swift
//  PawsHealth
//
//  Created by Pinto Diaz, Roger on 6/27/20.
//  Copyright © 2020 Hoowie. All rights reserved.
//

import UIKit

let minPhotoDistance: Double = 21.5
let minZoomDistance = 0.0015
let maxPhotoSide: CGFloat = 1350 /// Instagram max side

struct k {

    static let appName: String = Bundle.main.infoDictionary![kCFBundleNameKey! as String] as! String
    static let compressionQuality: CGFloat = 0.7

    struct paths {

        static let posts = "posts"
    }

    struct firebase {

        /// Database folder references
        static let users             = "users"
        static let posts             = "posts"
        static let credits           = "credits"
        static let friends           = "friends"
        static let feed              = "feed"
        static let premiumPosts      = "prem_posts"
        static let privateData       = "priv"
        static let publicData        = "pub"
        static let deleteAccount     = "deleteAccount"
        static let report            = "report"
        static let feedback          = "feedback"
        static let minimumAppVersion = "min_app_ver"

        /// Post database data
        static let latitude          = "lat"
        static let longitude         = "long"
        static let locationRef       = "ref"
        static let url               = "url"
        static let userId            = "userId"
        static let isAd              = "ad"
        static let premium           = "prem"
        static let hidden            = "hid"

        /// Post struct info
        static let postId            = "post_id"

        /// User data
        static let name              = "name"
        static let lastName          = "last_name"
        static let email             = "email"
        static let provider          = "provider"
        static let profilePicture    = "profile_picture"
        static let tipped            = "tipped"
    }

    struct nibs {

        static let mainTab = "MainTabVC"
    }

    struct inAppPurchase {

        static let get1Credit  = "Credits_pack_1"
        static let get5Credits  = "Credits_pack_5"
        static let get10Credits = "Credits_pack_10"
    }

    struct userDefs {

        static let reviewRequested = "reviewRequested"
        static let selectedImage = "selectedImage"
        static let shouldShowTipsView = "shouldShowTipsView"
        static let userTipped = "userTipped"
    }

    struct notifications {

        static let postUpdated = Notification.Name("postUpdated")
    }
}
