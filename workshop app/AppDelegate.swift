//
//  AppDelegate.swift
//  workshop app
//
//  Created by Leo Dion on 5/19/19.
//  Copyright © 2019 Leo Dion. All rights reserved.
//

import UIKit

protocol TabItemable {
  func configureTabItem(_ tabItem : UITabBarItem)
}

extension UITabBarController {
  convenience init(navigationRootViewControllers: [UIViewController], animated : Bool = false) {
    self.init()
    
    let viewControllers = navigationRootViewControllers.map
    { rootViewController -> UIViewController in
      let viewController = UINavigationController(rootViewController: rootViewController)
      if let tabItemable = rootViewController as? TabItemable {
        tabItemable.configureTabItem(viewController.tabBarItem)
      }
      return viewController
    }
    self.setViewControllers(viewControllers, animated: animated)
  }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  let navigationRootViewControllers = [UsersTableViewController(), PostsTableViewController(), CommentsTableViewController()]

  func makeWindow(keyAndVisibleWithViewController rootViewController: UIViewController?) -> UIWindow {
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.rootViewController = UITabBarController(navigationRootViewControllers: navigationRootViewControllers)
    window.makeKeyAndVisible()
    return window
  }
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    self.window = makeWindow(keyAndVisibleWithViewController: UITabBarController(navigationRootViewControllers: navigationRootViewControllers))
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}

