//
//  AppDelegate.swift
//  Whichflix
//
//  Created by Dasmer Singh on 2/22/20.
//  Copyright © 2020 Dastronics. All rights reserved.
//

import UIKit
import Alamofire
import Amplitude

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let session: Alamofire.Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.headers["X-Device-ID"] = UIDevice.current.identifierForVendor!.uuidString
        return Alamofire.Session(configuration: configuration)
    }()

    private lazy var electionsViewController: ElectionsViewController = {
        let viewController = ElectionsViewController(session: session)
        return viewController
    }()

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Amplitude.instance()?.initializeApiKey("ece181048917b087416088f5ef8c9833")
        // Override point for customization after application launch.
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UINavigationController(rootViewController: electionsViewController)
        window.makeKeyAndVisible()

        self.window = window

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

        // Determine who sent the URL.
        let sendingAppID = options[.sourceApplication]
        print("source application = \(sendingAppID ?? "Unknown")")

        // Process the URL.
        guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
            let params = components.queryItems,
            let queryItem = params.first,
            queryItem.name == "id",
            let electionID = queryItem.value else {
                print("Invalid URL")
                return false
        }
        electionsViewController.joinElectionWithID(electionID)

        return true

    }

}
