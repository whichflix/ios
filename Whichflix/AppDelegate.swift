//
//  AppDelegate.swift
//  Whichflix
//
//  Created by Dasmer Singh on 2/22/20.
//  Copyright © 2020 Dastronics. All rights reserved.
//

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let session: Alamofire.Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.headers["X-Device-ID"] = UIDevice.current.identifierForVendor!.uuidString
        return Alamofire.Session(configuration: configuration)
    }()

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = ElectionsViewController(session: session)
        window.rootViewController = UINavigationController(rootViewController: viewController)
        window.makeKeyAndVisible()

        self.window = window

        return true
    }
}
