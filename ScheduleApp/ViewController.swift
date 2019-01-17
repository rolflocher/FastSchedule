//
//  ViewController.swift
//  ScheduleApp
//
//  Created by Rolf Locher on 1/15/19.
//  Copyright © 2019 Rolf Locher. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet var scheduleImageView: UIImageView!
    
    @IBOutlet var randomButton: UIButton!
    
    
    @IBOutlet var blurView: UIVisualEffectView!
    
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
        guard let url = URL(string: "https://stackoverflow.com") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBOutlet var aboutButton: UIButton!
    
    @IBAction func aboutButtonPressed(_ sender: Any) {
        
    }
    
    
    
    
    @IBAction func randomPressed(_ sender: Any) {
        
        let session = URLSession(configuration: .default)
        
        let imageURL = URL(string: "https://picsum.photos/375/667/?random")!
        
        let downloadPicTask = session.dataTask(with: imageURL) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading picture: \(e)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        let image = UIImage(data: imageData)
                        DispatchQueue.main.async{
                            
                            //                            UIView.animate(withDuration: 2, delay: 0.0, options: [], animations: {
                            //                                self.CloudImageView.image = image
                            //                            }, completion: nil)
                            UIView.transition(with: self.scheduleImageView,
                                              duration:0.5,
                                              options: .transitionCrossDissolve,
                                              animations: { self.scheduleImageView.image = image },
                                              completion: nil)
                            
                            //self.CloudImageView.image = image
                            
                            
                            
                        }
                        let imageData: Data = image!.pngData()! as Data
                        
                        if let userDefaults = UserDefaults(suiteName: "group.rlocher.schedule") {
                            userDefaults.set(imageData, forKey: "schedule1")
                            userDefaults.synchronize()
                        }
                        // Do something with your image.
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.secondUploadButton.isHidden = true
        self.sourceButton.isHidden = true
        self.aboutButton.isHidden = true
        self.randomButton.isHidden = true
        //self.heightText.keyboardType = UIKeyboardType.numberPad
        // Do any additional setup after loading the view, typically from a nib.
        self.secondBlurView.isHidden=true
        self.secondBlurView.layer.cornerRadius = 10.0
        self.secondBlurView.clipsToBounds = true
        
        self.blurView.layer.cornerRadius = 15.0
        self.blurView.clipsToBounds = true
        self.blurView.isHidden=true
        self.uploadButton.isHidden=true
        if let userDefaults = UserDefaults(suiteName: "group.rlocher.schedule") {
            
            if userDefaults.data(forKey: "schedule1") != nil {
                self.scheduleImageView.image = UIImage(data:userDefaults.data(forKey: "schedule1")!)
                self.secondBlurView.isHidden=false
                self.secondUploadButton.isHidden = false
                self.sourceButton.isHidden = false
                self.aboutButton.isHidden = false
                self.randomButton.isHidden=true
                self.randomButton.isHidden = false
            }
            else {
                self.blurView.isHidden=false
                self.uploadButton.isHidden=false
            }
        }
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        longPressRecognizer.minimumPressDuration = 0.5
        self.scheduleImageView.addGestureRecognizer(longPressRecognizer)
        self.scheduleImageView.isUserInteractionEnabled = true
        // Do any additional setup after loading the view, typically from a nib.
    }
    
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
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            print(error)
        } else {
            print("saved?")
        }
    }
    
    
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
            
            self.blurView.isHidden=true
            self.uploadButton.isHidden=true
            
            
            dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func uploadPressed(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum;
        self.present(imagePicker, animated: true, completion: nil)
        
        
    }
    
}

