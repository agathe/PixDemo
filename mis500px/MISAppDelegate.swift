//
//  AppDelegate.swift
//  mis500px
//
//  Created by Agathe Battestini on 10/23/15.
//  Copyright © 2015 Misberri. All rights reserved.
//

import UIKit

@UIApplicationMain
class MISAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let initialViewController = storyboard.instantiateViewControllerWithIdentifier("rootNavigationController") as! UINavigationController
        
        // View models should be passed to a VC, and not created by it
        let photosViewModel = MISPhotosViewModel()
        let photosViewController = initialViewController.viewControllers[0] as! MISPhotosViewController
        photosViewController.viewModel = photosViewModel
        
        // test data
        let user = MISUserModel( "victor", "hugo")
        let photo = MISPhotoModel(name: "Beautiful Photo", user: user, surl: "https://drscdn.500px.org/photo/126156197/w%3D140_h%3D140/1f0d85b746c4b327a575d6488390ad53?v=2")
        photosViewModel.data.append(photo)

        self.window?.rootViewController = initialViewController
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
    }


}

