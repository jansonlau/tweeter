//
//  DetailViewController.swift
//  Tweeter
//
//  Created by Janson Lau on 12/7/16.
//  Copyright © 2016 Janson Lau. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var profilePicImage: UIImageView!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!

    var textFromSegue : String?
    var profilePicFromSegue:UIImage?
    var usernameFromSegue : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Text from segue \(textFromSegue)")

        // Do any additional setup after loading the view.
        tweetTextLabel.text = textFromSegue
        profilePicImage.image = profilePicFromSegue
        usernameLabel.text = usernameFromSegue
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
