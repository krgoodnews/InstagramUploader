//
//  AppDelegate.swift
//  InstagramUploader
//
//  Created by Yunsu Guk on 2020/01/15.
//  Copyright © 2020 Yunsu Guk. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    window = UIWindow()
    window?.makeKeyAndVisible()
    let navVC = UINavigationController(rootViewController: UploadImageViewController())
    window?.rootViewController = navVC

    return true
  }

}

