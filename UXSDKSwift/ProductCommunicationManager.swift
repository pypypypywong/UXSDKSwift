//
//  ProductCommunicationManager.swift
//
//  Created by Arnaud Thiercelin on 3/22/17.
//

import UIKit
import DJISDK

class ProductCommunicationManager: NSObject {
    
    let FLIGHT_CONTROLLER = "flightController"
    let REMOTE_CONTROLLER = "remoteController"
    
    // Set this value to true to use the app with the Bridge and false to connect directly to the product
    let enableBridgeMode = false
    
    // When enableBridgeMode is set to true, set this value to the IP of your bridge app.
    let bridgeAppIP = "10.0.1.5"
    
    func registerWithSDK() {
        let appKey = Bundle.main.object(forInfoDictionaryKey: SDK_APP_KEY_INFO_PLIST_KEY) as? String
        
        if (appKey != nil && appKey!.isEmpty == false) {
            print("App Key successfully created")
            DJISDKManager.registerApp(with: self)
        } else {
            print("App Key not created. Please enter your app key in the info.plist")
            return
        }
    }
}

extension ProductCommunicationManager : DJISDKManagerDelegate {
    func appRegisteredWithError(_ error: Error?) {
        
        if (error?.localizedDescription == nil) {
            print("No errors. SDK Registered successfully")
        } else {
            print("SDK Not Registered - Error \(String(describing: error?.localizedDescription)). Please enter your app key in the info.plist")
        }
        
        if enableBridgeMode {
            DJISDKManager.enableBridgeMode(withBridgeAppIP: bridgeAppIP)
        } else {
            DJISDKManager.startConnectionToProduct()
        }
    }
    
    func productConnected(_ product: DJIBaseProduct?) {
        print("Remote Controller connected")
    }
    
    func productDisconnected() {
        print("Remote Controller disconnected")
    }
    
    func componentConnected(withKey key: String?, andIndex index: Int) {
        if (key == FLIGHT_CONTROLLER) {
            print("isConnectedToDrone, key = \(key!), index = \(index)")
        } else if (key == REMOTE_CONTROLLER) {
            print("isConnectedToRemoteControl, key = \(key!), index = \(index)")
        }
    }
    
    func componentDisconnected(withKey key: String?, andIndex index: Int) {
        if (key == FLIGHT_CONTROLLER) {
            print("isConnectedToDrone, key = \(key!), index = \(index)")
        } else if (key == REMOTE_CONTROLLER) {
            print("isConnectedToRemoteControl, key = \(key!), index = \(index)")
        }
    }
}
