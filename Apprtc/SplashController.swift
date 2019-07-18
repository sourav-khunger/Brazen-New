//
//  SplashController.swift
//  Apprtc
//
//  Created by Amit Singh on 30/06/19.
//  Copyright © 2019 Dhilip. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)
class SplashController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.isNavigationBarHidden = true
    }

    @IBAction func btnScanQRCodeAction(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QRScannerController") as! QRScannerController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnCallAgainAction(_ sender: Any) {
        
        if UserDefaults.standard.value(forKey: "QRCode") as? String ?? "" != "" {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RTCVideoChatViewController") as! RTCVideoChatViewController
            vc.roomName = UserDefaults.standard.value(forKey: "QRCode") as? NSString ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            let alert = UIAlertController(title: "Apprtc Demo", message: "Please scan QR code again!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
