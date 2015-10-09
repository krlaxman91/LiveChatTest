//
//  AppDelegate.swift
//  ChatTest
//
//  Created by Laxman on 08/10/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit
import CoreData


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var recentView: RecentView?
    var groupsView: GroupsView?
    var peopleView: PeopleView?
    var settingsView: SettingsView?
    var tabBarController: UITabBarController?

    
    var viewController: ViewController?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
       
        Parse.setApplicationId("Az5UGI1aW3sdPpDgOGRj72SgpG4CkJFLVXfgA94U", clientKey: "yOzGePANMNMooQN5wukzvtyDSxiOqAdkQl1dNMn4")
        
        PFTwitterUtils.initializeWithConsumerKey("kS83MvJltZwmfoWVoyE1R6xko", consumerSecret: "YXSupp9hC2m1rugTfoSyqricST9214TwYapQErBcXlP1BrSfND")
        

        
        
        
        
       // [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:nil];

        //        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.recentView = RecentView(nibName: "RecentView", bundle: nil)
        self.groupsView = GroupsView(nibName: "GroupsView", bundle: nil)
         self.peopleView = PeopleView(nibName: "PeopleView", bundle: nil)
         self.settingsView = SettingsView(nibName: "SettingsView", bundle: nil)
        
      
        let navController1 = NavigationController(rootViewController: self.recentView!)
        let navController2 = NavigationController(rootViewController: self.groupsView!)
        let navController3 = NavigationController(rootViewController: self.peopleView!)
        let navController4 = NavigationController(rootViewController: self.settingsView!)
        
      
        self.tabBarController = UITabBarController()
       
        let controllers = [navController1, navController2 , navController3 , navController4]
        
        self.tabBarController?.viewControllers = controllers
            //NSArray(object: navController1, navController2 , navController3 , navController4 , nil)
        self.tabBarController?.tabBar.translucent = false
        self.tabBarController?.selectedIndex = 0
        
        
         self.viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ViewController") as? ViewController
        // .instantiatViewControllerWithIdentifier() returns AnyObject! this must be downcast to utilize it
        let navController = NavigationController(rootViewController: self.viewController!)

        
       self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }

    //MARK:-  Facebook responses
 
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
   
    
    

}

