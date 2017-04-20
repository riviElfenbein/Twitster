//
//  Api.swift
//  Twitster
//
//  Created by Rivi Elf on 19/04/2017.
//  Copyright © 2017 Rivi Elf. All rights reserved.
//

import Foundation
import TwitterKit
import Fabric

public class Api {
    public class func startSearchByWord(client:TWTRAPIClient, searchWord: String, sucess:  @escaping ((_ results: Array<TWTRTweet>?) -> ()),
                           failure: @escaping ((_ err: Error?)-> ())) {
        let searchToSend = searchWord.replacingOccurrences(of: " ", with: "%20")
        let searchEndpoint = "https://api.twitter.com/1.1/search/tweets.json?q=%23" + searchToSend + "&result_type=recent"
        var clientError : NSError?
        let request = client.urlRequest(withMethod: "GET", url: searchEndpoint, parameters: ["": ""], error: &clientError)
        
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if connectionError != nil {
                print("Error: \(connectionError)")
                failure(connectionError!)
                return
            }
            
            if data != nil {
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    let dict =  json as! NSDictionary
                    
                    if (dict["statuses"] != nil) {
                        let statuses = dict["statuses"] as? Array<NSDictionary>
                        
                        if statuses != nil {
                            let tweets = TWTRTweet.tweets(withJSONArray: statuses)
                            sucess(tweets as? Array<TWTRTweet>)
                            
                            
                        }
                        
                        
                        
                    }
                } catch let jsonError as NSError {
                    print("json error: \(jsonError.localizedDescription)")
                }
            }
        }
        
        
    }
    

}
