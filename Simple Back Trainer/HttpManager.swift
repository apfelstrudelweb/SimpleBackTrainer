//
//  HttpManager.swift
//
//  Created by Ulrich Vormbrock on 03/04/18.
//  Copyright © 2018 Ulrich Vormbrock. All rights reserved.
//

import UIKit

class HttpManager {
    
    static public func hasUpdates(_ url: String, params: [String:Any], httpMethod: API.HttpMethod, receivedResponse:@escaping (_ succeeded:Bool) -> ()) {
        
        let urlString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        var request = URLRequest(url: URL(string: API.host + urlString!)!)
        request.httpMethod = httpMethod.rawValue
        request.timeoutInterval = 20
        request.cachePolicy = .reloadIgnoringLocalCacheData
        
        if(httpMethod == API.HttpMethod.POST) {
            request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            let storedDate = UserDefaults.standard.object(forKey: "jsonModifiedDate") as? String
            var lastModifiedDate: String?
            
            if (response != nil && data != nil) {
                
                if let httpResp: HTTPURLResponse = response as? HTTPURLResponse {
                    lastModifiedDate = httpResp.allHeaderFields["Last-Modified"] as? String
                } else {
                    receivedResponse(false)
                }
                
                if storedDate != lastModifiedDate {
                    UserDefaults.standard.set(lastModifiedDate!, forKey: "jsonModifiedDate")
                    UserDefaults.standard.synchronize()
                    receivedResponse(true)
                } else {
                    receivedResponse(false)
                }
                
            } else {
                receivedResponse(false)
            }
        }
        task.resume()
    }
    
    static public func requestToServer(_ url: String, params: [String:Any], httpMethod: API.HttpMethod, isZipped:Bool, receivedResponse:@escaping (_ succeeded:Bool, _ response:[String:Any],_ data:Data?) -> ()){
        
        let urlString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        var request = URLRequest(url: URL(string: API.host + urlString!)!)
        request.httpMethod = httpMethod.rawValue
        request.timeoutInterval = 20
        request.cachePolicy = .reloadIgnoringLocalCacheData
        //        let accessToken = UserDefaultsCustom.getAccessToken()
        //        if accessToken.count > 0{
        //            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        //        }
        if(httpMethod == API.HttpMethod.POST) {
            request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
            if isZipped == false {
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            } else {
                request.addValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
                request.addValue("application/octet-stream", forHTTPHeaderField: "Content-Encoding: gzip")
            }
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        }
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            
            if (response != nil && data != nil) {
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any] {
                        receivedResponse(true, json, data)
                    } else {
                        let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)    // No error thrown, but not NSDictionary
                        print("Error could not parse JSON: \(jsonStr ?? "")")
                        receivedResponse(false, [:], nil)
                    }
                } catch let parseError {
                    print(parseError)                                                          // Log the error thrown by `JSONObjectWithData`
                    let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print("Error could not parse JSON: '\(jsonStr ?? "")'")
                    receivedResponse(false, [:], nil)
                }
                
            } else {
                receivedResponse(false, [:], nil)
                
            }
        }
        task.resume()
    }
    
}
