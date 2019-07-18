//
//  QRScannerController.swift
//  Apprtc
//
//  Created by Amit Singh on 30/06/19.
//  Copyright © 2019 Dhilip. All rights reserved.
//

import UIKit
import AVFoundation
@available(iOS 10.0, *)
class QRScannerController: UIViewController {

    
    
    @IBOutlet weak var scannerView: UIView!
    
    var captureSession = AVCaptureSession()
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?


    
    let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                              AVMetadataObject.ObjectType.code39,
                              AVMetadataObject.ObjectType.qr]
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scannerView.frame = self.view.frame
      
        // Get the back-facing camera for capturing videos
        if #available(iOS 10.2, *) {
            
           
            
            guard  let captureDevice = AVCaptureDevice.default(for: .video) else {
                print("Failed to get the camera device")
                return
            }
            
            do {
                // Get an instance of the AVCaptureDeviceInput class using the previous device object.
                let input = try AVCaptureDeviceInput(device: captureDevice)
                
                // Set the input device on the capture session.
                captureSession.addInput(input)
                
                // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
                let captureMetadataOutput = AVCaptureMetadataOutput()
                captureSession.addOutput(captureMetadataOutput)
                
                // Set delegate and use the default dispatch queue to execute the call back
                captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
                //            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
                
            } catch {
                // If any error occurs, simply print it out and don't continue any more.
                print(error)
                return
            }
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = scannerView.layer.bounds
            scannerView.layer.addSublayer(videoPreviewLayer!)
            
            
            // Start video capture.
            captureSession.startRunning()
            
            // Move the message label and top bar to the front
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                scannerView.addSubview(qrCodeFrameView)
                scannerView.bringSubview(toFront: qrCodeFrameView)
            }
        } else {
            // Fallback on earlier versions
        }
 
 
    }

}
@available(iOS 10.0, *)
extension QRScannerController: AVCaptureMetadataOutputObjectsDelegate {
    
    
     //func captureOutput(_ output: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!)
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection)
    {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                
                
                captureSession.stopRunning()
                
                let alertController = UIAlertController(title: "Result", message: "Your scanned code : \(metadataObj.stringValue!)", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                   
                    if metadataObj.stringValue == ""
                    {
                        return
                    }
                    
                    let str : String = metadataObj.stringValue!
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "RTCVideoChatViewController") as! RTCVideoChatViewController
                    vc.roomName = NSString(string: str)
                    
                    UserDefaults.standard.setValue(NSString(string: metadataObj.stringValue ?? ""), forKey: "QRCode")
                    UserDefaults.standard.synchronize()
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                })
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
                
              
            }
        }
        
    }
    

    
}
