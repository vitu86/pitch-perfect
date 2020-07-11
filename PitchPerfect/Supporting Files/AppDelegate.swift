//
//  AppDelegate.swift
//  PitchPerfect
//
//  Created by Vitor Costa on 22/08/18.
//  Copyright © 2018 Vitor Costa. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)

        let homeController = HomeController()
        let navigationController = UINavigationController(rootViewController: homeController)

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }
}
