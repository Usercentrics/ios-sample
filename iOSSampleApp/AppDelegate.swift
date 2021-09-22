//
//  AppDelegate.swift
//  iOSSampleApp
//
//  Created by Pedro Araujo on 13/09/2021.
//

import UIKit
import Usercentrics
import UsercentricsUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        /// Initialize Usercentrics with your configuration
        let options = UsercentricsOptions(settingsId: "Yi9N3aXia")
        options.loggerLevel = .debug
        UsercentricsCore.configure(options: options)

        let rootNavigationController = UINavigationController(rootViewController: UsercentricsUIViewController())
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootNavigationController
        window?.makeKeyAndVisible()

        return true
    }
}
