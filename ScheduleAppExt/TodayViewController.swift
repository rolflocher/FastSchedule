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
    
    // Interface Builder connections
    // Button actions and references for hiding, etc.
    @IBOutlet var widgetImageView: UIImageView!
    
    @IBOutlet var uploadButton: UIButton!
    
    @IBAction func uploadButtonPressed(_ sender: Any) {
        extensionContext?.open(URL(string: "myFirstURL://")! , completionHandler: nil)
    }
    
    // Begin application
    // Checks for previous data in UserDefaults
    // Sets preferred size
    override func viewDidLoad() {
        super.viewDidLoad()
        if let userDefaults = UserDefaults(suiteName: "group.rlocher.schedule") {
            if userDefaults.data(forKey: "schedule1") != nil {
                self.widgetImageView.image = UIImage(data:userDefaults.data(forKey: "schedule1")!)
            }
            else {
                self.widgetImageView.image = nil
            }
        }
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        self.preferredContentSize = CGSize(width: 200, height: 550)
    }
    
    // Handles change from compact to expanded view
    // Image is presented in expanded
    // Link to app is presented in compact
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
