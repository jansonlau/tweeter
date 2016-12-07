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
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")! as URL!, consumerKey: "BNCoMewSq5ed62jqhHtEuLrye", consumerSecret: "YR5i7ppZLEoAXbYLGFnf2cBw2A5kwLSyxsLE3ynD02hWpd5KXq")
    
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
    
//    func getFollowers(screenname: String, success: ([Dictionary]) -> (), failure: (Error) -> ())
//    {
//        get("1.1/followers/list.json?screen_name=\(screenname)", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: AnyObject?) in
//            let dictionaries = response as! Dictionary
//            
//            let users = dictionaries["users"] as! [Dictionary]
//            
//            success(users)
//        
//        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
//            failure(error)
//        })
//        
//    }
    
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
            print("Error TwitterClient1: \(error?.localizedDescription)")
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
            print("Error TwitterClient2: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        })
    }
    
//    func logout() {
//        User.currentUser = nil
//        deauthorize()
//        
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLogout"), object: nil)
//    }
}
