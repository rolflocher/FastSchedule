//
//  TodayViewController.swift
//  ScheduleAppExt
//
//  Created by Rolf Locher on 1/15/19.
//  Copyright © 2019 Rolf Locher. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet var widgetImageView: UIImageView!
    
    @IBOutlet var uploadButton: UIButton!
    
    @IBOutlet var helpText: UILabel!
    
    
    @IBAction func uploadButtonPressed(_ sender: Any) {
        
        print("sending you to app")
        extensionContext?.open(URL(string: "myFirstURL://")! , completionHandler: nil)
        
//        self.present(imagePicker, animated: true, completion: nil)
    }
    
    var isPickingImage = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.helpText.isHidden = true
        if let userDefaults = UserDefaults(suiteName: "group.rlocher.schedule") {
            if userDefaults.data(forKey: "schedule1") != nil {
                self.widgetImageView.image = UIImage(data:userDefaults.data(forKey: "schedule1")!)
            }
        }
        
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        if self.widgetImageView.image != nil {
            if let userDefaults = UserDefaults(suiteName: "group.rlocher.schedule") {
                self.preferredContentSize = CGSize(width: 200, height: userDefaults.integer(forKey: "schedule2"))
                print(userDefaults.integer(forKey: "schedule2"))
            }
        }
        else {
            self.preferredContentSize = CGSize(width: 200, height: 550)
        }
        
        // Do any additional setup after loading the view from its nib.
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        
        
        if activeDisplayMode == .expanded {
            UIView.animate(withDuration: 5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.25, options: [], animations: { () -> Void in
                self.preferredContentSize = CGSize(width: 200, height: 400)
                
                self.uploadButton.isHidden = true
                self.widgetImageView.isHidden = false
                
                
            }, completion: nil)
            
        }
        else {
            UIView.animate(withDuration: 5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.25, options: [], animations: { () -> Void in
                self.preferredContentSize = CGSize(width: 200, height: 30)
                self.uploadButton.isHidden = false
                
                
                
                self.widgetImageView.isHidden = true
            }, completion: nil)
        }
        
    }
    
}
