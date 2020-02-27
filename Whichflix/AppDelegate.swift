//
//  AppDelegate.swift
//  Whichflix
//
//  Created by Dasmer Singh on 2/22/20.
//  Copyright © 2020 Dastronics. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = ElectionsViewController()
        window.rootViewController = UINavigationController(rootViewController: viewController)
        window.makeKeyAndVisible()

        self.window = window

        return true
    }
}
