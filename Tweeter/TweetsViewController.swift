//
//  TweetsViewController.swift
//  Tweeter
//
//  Created by Janson Lau on 12/5/16.
//  Copyright © 2016 Janson Lau. All rights reserved.
//

import UIKit
import NSDate_TimeAgo

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tweetTableView: UITableView!
    
    var tweets : [Tweet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTableView.delegate = self
        tweetTableView.dataSource = self
        
        // Get home timeline
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
             
            for tweet in tweets {
                print(tweet.text!)
            }
            
            
            self.tweetTableView.reloadData()
        }, failure: { (error: Error) in
            print("Error TweetsVC: \(error.localizedDescription)")
        })
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count 
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        let tweet = tweets[indexPath.row]
        
        // Tweet body
        cell.tweetLabel.text = tweets[indexPath.row].text as String?
        
        // Username
        let userParticular = tweet.author
        cell.usernameLabel.text = userParticular?.name as String?
        cell.screennameLabel.text = "@\((userParticular?.screenname)! as String)"
        
        // Profile image
        if let profilePicURL = userParticular!.profileUrl {
            
            
            let data = NSData(contentsOf:profilePicURL as URL)
            if data != nil {
                cell.profileImageView.image = UIImage(data:data! as Data)
            }
        }
        
        // Time ago date
        let date = tweet.timestamp! as NSDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        //let dateyString = dateFormatter.stringFromDate(datey)
        let dateRelative = date.dateTimeAgo()
        cell.hoursAgoLabel.text = dateRelative
        
        return cell 
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination.restorationIdentifier == "DetailViewController" {
            let vc = segue.destination as! DetailViewController
            let indexPath1 = tweetTableView.indexPath(for: sender as! TweetCell)
            let tweety = self.tweets[indexPath1!.row]
            
            //Send tweet
            vc.textFromSegue = tweety.text as String?
            
            //Send pic
            let user = tweety.author
            let picURL = user?.profileUrl
            let data = NSData(contentsOf:picURL! as URL)
            
            if data != nil {
                let picImage = UIImage(data:data! as Data)
                vc.profilePicFromSegue = picImage
            }
            //Send username
            vc.usernameFromSegue = user?.name as String?
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

//    @IBAction func onLogoutButton(_ sender: Any) {
//        TwitterClient.sharedInstance?.logout()
//    }
}
