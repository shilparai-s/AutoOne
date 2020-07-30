//
//  AppDelegate.swift
//  AutoOne
//
//  Created by Shilpa S on 18/11/19.
//  Copyright © 2019 Shilpa S. All rights reserved.
//

import UIKit

@UIApplicationMain


class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //Customisation
        UINavigationBar.appearance().barTintColor = UIColor(red: 74.0/255.0, green: 141.0/255.0, blue: 214.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.medium)]
        UIBarButtonItem.appearance().tintColor = UIColor.white
        
        return true
    }

 

}

