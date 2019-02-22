//
//  ViewController.swift
//  UXSDKSwift
//
//  Created by Bill Malkin on 22/2/19.
//  Copyright © 2019 Bill Malkin. All rights reserved.
//

import DJIUXSDK
import UIKit

class ViewController: DUXDefaultLayoutViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        guard let connectedKey = DJIProductKey(param: DJIParamConnection) else {
            return;
        }
        
        DispatchQueue.main.async {
            print(String(describing: type(of: self)).components(separatedBy: ".").last!, #function, #line)
            self.productConnected()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            DJISDKManager.keyManager()?.startListeningForChanges(on: connectedKey, withListener: self, andUpdate: { (oldValue: DJIKeyedValue?, newValue : DJIKeyedValue?) in
                if newValue != nil {
                    if newValue!.boolValue {
                        DispatchQueue.main.async {
                            print(String(describing: type(of: self)).components(separatedBy: ".").last!, #function, #line)
                            self.productConnected()
                        }
                    } else {
                        DispatchQueue.main.async {
                            print(String(describing: type(of: self)).components(separatedBy: ".").last!, #function, #line)
                            self.productDisconnected()
                        }
                    }
                }
            })
            
            DJISDKManager.keyManager()?.getValueFor(connectedKey, withCompletion: { (value:DJIKeyedValue?, error:Error?) in
                if let unwrappedValue = value {
                    if unwrappedValue.boolValue {
                        DispatchQueue.main.async {
                            print(String(describing: type(of: self)).components(separatedBy: ".").last!, #function, #line)
                            self.productConnected()
                        }
                    }
                }
            })
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        DJISDKManager.keyManager()?.stopAllListening(ofListeners: self)
    }
    
    func productConnected() {
        print(String(describing: type(of: self)).components(separatedBy: ".").last!, #function, #line)
        let newProduct = DJISDKManager.product()
        if (newProduct == nil) {
            print("Product Connection Error")
            return;
        }
        print("Product Connected")
        DJISDKManager.startConnectionToProduct()
    }
    
    func productDisconnected() {
        print("Product Disconnected")
    }
}

