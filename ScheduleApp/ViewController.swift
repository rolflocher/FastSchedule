//
//  ViewController.swift
//  ScheduleApp
//
//  Created by Rolf Locher on 1/15/19.
//  Copyright © 2019 Rolf Locher. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    // Interface Builder connections
    // Button actions and references for hiding, etc.
    @IBOutlet var scheduleImageView: UIImageView!
    
    @IBOutlet var randomButton: UIButton!
    
    @IBOutlet var aboutTextView: UITextView!
    
    @IBOutlet var secondBlurView: UIVisualEffectView!
    
    @IBOutlet var uploadButton: UIButton!
    
    @IBOutlet var secondUploadButton: UIButton!
    
    @IBAction func secondUploadButtonPressed(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum;
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBOutlet var sourceButton: UIButton!
    
    @IBAction func sourceButtonPressed(_ sender: Any) {
        guard let url = URL(string: "https://github.com/rolflocher/FastSchedule") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBOutlet var aboutButton: UIButton!
    
    @IBAction func aboutButtonPressed(_ sender: Any) {
        self.aboutTextView.isHidden=false
        self.donateButton.isHidden=false
        
        self.secondUploadButton.isHidden = true
        self.sourceButton.isHidden = true
        self.aboutButton.isHidden = true
        self.randomButton.isHidden=true
    }
    
    @IBAction func randomPressed(_ sender: Any) {
        self.getRandomImage()
    }
    
    @IBOutlet var donateButton: UIButton!
    
    @IBAction func donateButtonPressed(_ sender: Any) {
        guard let url = URL(string: "https://www.paypal.me/rolfspaypal") else { return }
        UIApplication.shared.open(url)
    }
    
    // Begin application
    // Hides background elements
    // Checks for previous data in UserDefaults
    // Initializes gesture recognizers
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.uploadButton.isHidden=true
        self.donateButton.isHidden=true
        self.aboutTextView.isHidden=true
        self.aboutTextView.isEditable=false
        
        self.secondBlurView.isHidden=false
        self.secondBlurView.layer.cornerRadius = 10.0
        self.secondBlurView.clipsToBounds = true
        self.secondUploadButton.isHidden = false
        self.sourceButton.isHidden = false
        self.aboutButton.isHidden = false
        self.randomButton.isHidden = false
        
        let tapPressRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapPressed))
        self.aboutTextView.addGestureRecognizer(tapPressRecognizer)
        self.aboutTextView.isUserInteractionEnabled = true
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        longPressRecognizer.minimumPressDuration = 0.5
        self.scheduleImageView.addGestureRecognizer(longPressRecognizer)
        self.scheduleImageView.isUserInteractionEnabled = true
        
        if let userDefaults = UserDefaults(suiteName: "group.rlocher.schedule") {
            if userDefaults.data(forKey: "schedule1") != nil {
                self.scheduleImageView.image = UIImage(data:userDefaults.data(forKey: "schedule1")!)
            }
            else {
                self.getRandomImage()
            }
        }
    }
    
    // Downloads random image and assigns to UIImageView
    // Image data is saved in UserDefaults
    func getRandomImage () {
        let session = URLSession(configuration: .default)
        let imageURL = URL(string: "https://picsum.photos/375/667/?random")!
        let downloadPicTask = session.dataTask(with: imageURL) { (data, response, error) in
            if let e = error {
                print("Error downloading picture: \(e)")
            } else {
                if let res = response as? HTTPURLResponse {
                    print("Downloaded picture with response code \(res.statusCode)")
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        DispatchQueue.main.async{
                            UIView.transition(with: self.scheduleImageView,
                                              duration:0.5,
                                              options: .transitionCrossDissolve,
                                              animations: { self.scheduleImageView.image = image },
                                              completion: nil)
                        }
                        let imageData: Data = image!.pngData()! as Data
                        
                        if let userDefaults = UserDefaults(suiteName: "group.rlocher.schedule") {
                            userDefaults.set(imageData, forKey: "schedule1")
                            userDefaults.synchronize()
                        }
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        downloadPicTask.resume()
    }
    
    // Long press on background image - saves image to Gallery
    // ImageSaving var and threaded countdown controls number of saves
    var imageSaving = false
    @objc func longPressed(sender: UILongPressGestureRecognizer) {
        if !imageSaving {
            UIImageWriteToSavedPhotosAlbum(self.scheduleImageView.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            self.imageSaving = true
            DispatchQueue.global(qos: .background).async {
                self.countdown()
            }
        }
    }
    
    func countdown (){
        sleep(2)
        self.imageSaving = false
    }
    
    // ImagePickerController mandatory handling method after saved image
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            print(error)
        } else {
            print("saved")
        }
    }
    
    // Tap action, recieved from aboutTextView, "returns" to main screen
    @objc func tapPressed(sender: UITapGestureRecognizer) {
        self.aboutTextView.isHidden=true
        self.secondUploadButton.isHidden = false
        self.sourceButton.isHidden = false
        self.aboutButton.isHidden = false
        self.randomButton.isHidden=false
        self.donateButton.isHidden=true
    }
    
    // Upload from Gallery method handling selected image
    // Image data is saved to UserDefaults so it can be accessed by the widget
    let imagePicker = UIImagePickerController()
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            DispatchQueue.main.async {
                self.scheduleImageView.image = image
            }
            let imageData: Data = image.pngData()! as Data
            
            if let userDefaults = UserDefaults(suiteName: "group.rlocher.schedule") {
                userDefaults.set(imageData, forKey: "schedule1")
                userDefaults.synchronize()
            }
            
            self.secondBlurView.isHidden=false
            self.secondUploadButton.isHidden = false
            self.sourceButton.isHidden = false
            self.aboutButton.isHidden = false
            self.randomButton.isHidden=false
            
            self.uploadButton.isHidden=true
            
            dismiss(animated: true, completion: nil)
        }
    }
    
}

