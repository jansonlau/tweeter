//
//  PhotoViewController.swift
//  Tweeter
//
//  Created by Janson Lau on 12/6/16.
//  Copyright © 2016 Janson Lau. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var takePicButton: UIButton!
    @IBOutlet weak var photosButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        
        let photo = defaults.data(forKey: "photo")
        if(photo != nil) {
            photoImageView.image = UIImage(data: photo!)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clearPhoto(_ sender: Any) {
        photoImageView.image = nil 
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func takePictureAction(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = .camera
        vc.modalPresentationStyle = .fullScreen
        
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func showPhotosAction(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = .photoLibrary
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let photo = info[UIImagePickerControllerEditedImage] as? UIImage
        self.photoImageView.image = photo
        self.dismiss(animated: true, completion: nil)
        let defaults = UserDefaults.standard
        defaults.set(UIImageJPEGRepresentation(photo!, 1.0), forKey: "photo")
        defaults.synchronize()
    }
}
