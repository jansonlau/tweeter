//
//  TweetsViewController.swift
//  Tweeter
//
//  Created by Janson Lau on 12/5/16.
//  Copyright © 2016 Janson Lau. All rights reserved.
//

import UIKit

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
//                print(tweet.)
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
        
        
        
        return cell 
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
