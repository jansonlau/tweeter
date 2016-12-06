//
//  TwitterClient.swift
//  Tweeter
//
//  Created by Janson Lau on 12/5/16.
//  Copyright © 2016 Janson Lau. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    ///// Variables /////
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")! as URL!, consumerKey: "Sa3Gcd1bGfhOSs7RtvB29M3E7", consumerSecret: "qT5Zqsu39Gwu9z8xTpswlL7F8C53AYMEPh88h30UQyY7kt7TKY")
    
    var loginSuccess: (() -> ())?
    
    var loginFailure: ((Error) -> ())?
    
    ///// Methods /////
    
    ///// Home Timeline /////
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) { // If success, hand in array of Tweet without response. Else, give error.
        ///// Get home timeline /////
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries) // Pass in response of dictionaries into class Tweet
            
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) -> () in
            failure(error)
        })
    }
    
    ///// Current Account /////
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        ///// User info is printed out as "response" /////
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let userDictionary = response as! NSDictionary // Response is a dictionary of user information
            let user = User(dictionary: userDictionary)
            
            success(user)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    ///// Login /////
    func login(success:  @escaping () -> (), failure: @escaping (Error) -> ()) { // Declare closure
        loginSuccess = success
        loginFailure = failure
        
        
        // Log out first for BDBOAuth from previous sessions
        TwitterClient.sharedInstance?.deauthorize()
        
        // Request token URL
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: NSURL(string: "ITP342://oauth") as URL!, scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            
            // Authorize URL
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\((requestToken?.token)!)")! // Add query parameter by adding "?oauth_token=\(requestToken?.token)" (DON'T FORGET TO UNWRAP ALL OPTIONALS)
            
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            print("Requesting token URL")
            
        }, failure: { (error: Error?) in
            print("Error: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        })
    }
    
    ///// Open URL /////
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        // Fetch access token
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            print("Received access token")
            
            self.currentAccount(success: { (user: User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: Error) in
                self.loginFailure?(error)
            })
    
            print("Login successful")
            
        }, failure: { (error: Error?) in
            print("Error: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        })
    }
}
