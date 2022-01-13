//
//  AppDelegate.swift
//  TimeApp
//
//  Created by Tsibulko on 09.09.2020.
//  Copyright © 2020 Tsibulko. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var appCoordinator: AppCoordinator?

	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		FirebaseApp.configure()

		let navigationController = UINavigationController()
		navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
		navigationController.navigationBar.shadowImage = UIImage()
		navigationController.navigationBar.tintColor = .black

		let appRouter = AppRouter(navigationController: navigationController)
		let serviceLocator = ServiceLocator()
		let coordinator = AppCoordinator(appRouter: appRouter, serviceLocator: serviceLocator)

		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = navigationController
		window?.makeKeyAndVisible()

		coordinator.start()
		return true
	}
}
