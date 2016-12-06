//
//  User.swift
//  Tweeter
//
//  Created by Janson Lau on 12/5/16.
//  Copyright © 2016 Janson Lau. All rights reserved.
//

import UIKit

// Capture data from server
class User: NSObject {
    
    var name: NSString?
    var screenname: NSString?
    var profileUrl: NSURL?
    var tagLine: NSString?
    
    var dictionary: NSDictionary?
    
    // Deserialization
    init(dictionary: NSDictionary) { // API returns a dictionary
        self.dictionary = dictionary
        
        name = dictionary["name"] as? NSString
        screenname = dictionary["screen_name"] as? NSString
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        
        if let profileUrlString = profileUrlString { // If not nil, put it into "profileUrlString"
            profileUrl = NSURL(string: profileUrlString)
        }
        
        tagLine = dictionary["description"] as? NSString
    }
    
    static var _currentUser: User? // Class variable
    
    class var currentUser: User? {
        get {
            if _currentUser == nil { // If _currentUser is nil
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? NSData // Check if there is data inside currentUserData
                
                if let userData = userData {
                    let dictionary = try!
                        JSONSerialization.jsonObject(with: userData as Data, options: []) as! NSDictionary
                    
                    _currentUser = User(dictionary: dictionary) // If there is data, store it in _currentUser
                }
            }
            
            return _currentUser
        }

        set(user) {
            _currentUser = user  
            
            let defaults = UserDefaults.standard
            
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.set(nil, forKey: "currentUserData")
            }
            
            defaults.synchronize()
        }
    }
}
