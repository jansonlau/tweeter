//
//  Tweet.swift
//  Tweeter
//
//  Created by Janson Lau on 12/5/16.
//  Copyright © 2016 Janson Lau. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var text: NSString?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? NSString
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0 // If retweetCount exists, use it. Otherwise use 0
        
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString) as NSDate?
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]() // Create empty array of Tweet
    
        for dictionary in dictionaries { // Iterate through all dictionaries
            let tweet = Tweet(dictionary: dictionary) // Create a Tweet
            
            tweets.append(tweet) // Add a Tweet to array of tweet
        }
        
        return tweets // Return array
    }
}
