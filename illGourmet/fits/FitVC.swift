//
//  FitVC.swift
//  fits
//
//  Created by Vibes on 3/20/17.
//  Copyright © 2017 PZRT. All rights reserved.
//

import UIKit
import AVFoundation


class FitVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBAction func camera(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Action Sheet", message: "What would you like to do?", preferredStyle: .actionSheet)
        
        let sendButton = UIAlertAction(title: "Camera", style: .default, handler: { (action) -> Void in
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .camera
            imagePicker.cameraCaptureMode = .photo
            
            self.present(imagePicker, animated: true, completion: nil)
            
        })
        
        let  deleteButton = UIAlertAction(title: "Gallery", style: .default, handler: { (action) -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
            
        })
        
        let cancel = UIAlertAction(title : "Cancel", style: .cancel) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(sendButton)
        alertController.addAction(deleteButton)
        alertController.addAction(cancel)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var name: UILabel!
   
    @IBOutlet weak var text: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var price: UILabel!
    
    var fit : Fit?
    
    var index = 0
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? WebVC {
            destination.urlReceptacle = fit?.buyLink[index-1]
            
        }
    }
    
    @IBAction func webSegue(_ sender: Any) {
        
        self.performSegue(withIdentifier: "webSegue", sender: Any?.self)
    }
    
//    private func loadImage(atURL url: URL) -> UIImage? {
//        
//        if let data = try? Data(contentsOf: url) {
//            return UIImage(data: data)
//        }
//        
//        return nil
//    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    
        if index == 0 {
            fit?.loadImage(atURL: (fit?.imageURL)!, completion: { (fetchedImage) in
                DispatchQueue.main.async {
                    self.imageView.image = fetchedImage
                }
            })
            self.name.text = fit?.name
            self.text.text = fit?.text
            self.price.text = " "
            self.button.isHidden = true

        } else {
            fit?.loadImage(atURL: (fit?.productImage[index-1])!, completion: { (fetchedImage) in
                DispatchQueue.main.async {
                    self.imageView.image = fetchedImage
                }
            })
            self.name.text = fit?.brand[index-1]
            self.text.text = fit?.productName[index-1]
            self.price.text = "$ " + "\(fit!.price[index-1])"
            self.button.setTitle("Buy at " + (fit?.storeName[index-1])!, for: UIControlState.normal)
            button.layer.cornerRadius = 5
            
        }
        
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setValues(fit:Fit, index:Int) {
        
        self.fit = fit
        self.index = index
    }

    
    // MARK: - Navigation

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//         Get the new view controller using segue.destinationViewController.
//         Pass the selected object to the new view controller.
//    }
   

}

