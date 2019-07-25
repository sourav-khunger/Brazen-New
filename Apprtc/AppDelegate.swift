//
//  AppDelegate.swift
//  Apprtc
//
//  Created by Mahabali on 9/5/15.
//  Copyright (c) 2015 Mahabali. All rights reserved.
//
let appDelegate = UIApplication.shared.delegate as! AppDelegate


import UIKit
import WebRTC

import SocketIO

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
    let manager = SocketManager(socketURL: URL(string: "https://intense-bayou-55879.herokuapp.com/")!, config: [.log(true)])  //, .compress
  
    
    var strBatteryLevel : String = ""
    var strBatteryTemp : String = ""
    var strLati : String = ""
    var strLongi : String = ""
    var strNetworkSignal : String = ""
    var strUserName : String = ""
    var strWifiSignal : String = ""
    
    
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    RTCInitializeSSL()
    
    
    if UserDefaults.standard.value(forKey: "QRCode") as? String ?? "" != "" {
        if #available(iOS 10.0, *) {
            
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "SplashController") as! SplashController
            let nav = UINavigationController(rootViewController: redViewController)
            nav.isNavigationBarHidden = true

            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = nav
            
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    
    //socket io code for web sockets dynamic data updates.
    let socket = manager.defaultSocket


    socket.on(clientEvent: .connect) {data, ack in
        print("my socket connected")
        
        print("my socket data : \(data)")
        
       socket.emit("connect user", ["username": "shammi"])
        
    }



    socket.on("connect user") {data, ack in
        // guard let cur = data[0] as? Double else { return }

        print("new event connect Data : \(data)")

    }
    
    socket.on("jsondata") {data, ack in
       // guard let cur = data[0] as? Double else { return }

        print("InComing Data : \(data)")

        if let response = data as? [NSDictionary]
        {
            if response.count > 0
            {
                let dic : NSDictionary = response[0]
                
                    if let batteryL = dic.object(forKey: "batteryLevel") as? String
                    {
                        self.strBatteryLevel = batteryL
                    }
                
                if let batteryTemp = dic.object(forKey: "batteryTemp") as? String
                {
                    self.strBatteryTemp = batteryTemp
                }
               
                if let lati = dic.object(forKey: "latitute") as? String
                {
                    self.strLati = lati
                }
                
                if let longi = dic.object(forKey: "longitute") as? String
                {
                    self.strLongi = longi
                }
                
                if let networkSignal = dic.object(forKey: "networkSignal") as? String
                {
                    self.strNetworkSignal = networkSignal
                }
                
                if let userName = dic.object(forKey: "username") as? String
                {
                    self.strUserName = userName
                }
                
                if let wifiSignal = dic.object(forKey: "wifiSignal") as? String
                {
                    self.strWifiSignal = wifiSignal
                }
                
            }
            
        }
        
        
//        socket.emitWithAck("canUpdate", cur).timingOut(after: 0) {data in
//            socket.emit("update", ["amount": cur + 2.50])
//        }
//
//        ack.with("Got your currentAmount", "dude")
    }

    socket.connect()

    
    
    
    
    return true
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    RTCCleanupSSL();
  }
  
}

