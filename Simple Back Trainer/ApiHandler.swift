//
//  ApiHandler.swift
//
//  Created by Ulrich Vormbrock on 03/04/18.
//  Copyright © 2018 Ulrich Vormbrock. All rights reserved.
//

import UIKit
import CoreLocation

class ApiHandler {

    static public func call(apiName:String,params: [String : Any]?,httpMethod:API.HttpMethod,receivedResponse:@escaping (_ succeeded:Bool, _ response:[String:Any], _ data:Data?) -> ()) {
        if IJReachability.isConnectedToNetwork() == true {
            HttpManager.requestToServer(apiName, params: params!, httpMethod: httpMethod, isZipped: false, receivedResponse: { (isSucceeded, response, data) in
                DispatchQueue.main.async {
                    print(response)
                    if(isSucceeded){
                            receivedResponse(true, response, data)
                    } else {
                        receivedResponse(false, ["statusCode":0, "message":AlertMessage.SERVER_NOT_RESPONDING],nil)
                    }
                }
            })
        } else {
            receivedResponse(false, ["statusCode":0, "message":AlertMessage.NO_INTERNET_CONNECTION], nil)
        }
    }
}
