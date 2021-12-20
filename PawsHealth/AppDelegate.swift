//
//  AppDelegate.swift
//  PawsHealth
//
//  Created by Pinto Diaz, Roger on 6/26/20.
//  Copyright © 2020 Hoowie. All rights reserved.
//

import Firebase
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
