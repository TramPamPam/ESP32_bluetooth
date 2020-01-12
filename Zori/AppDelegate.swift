//
//  AppDelegate.swift
//  Zori
//
//  Created by Oleksandr Bezpalchuk on 4/10/18.
//  Copyright © 2018 ekreative. All rights reserved.
//

import UIKit
import CoreData
import netfox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        _ = CoreDataStackImplementation.shared
        NFX.sharedInstance().start()
        _ = BLEConnector.shared.centralManager
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            BLEConnector.shared.refresh()
        }
        return true
    }
    
}

