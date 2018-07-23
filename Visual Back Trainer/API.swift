//
//  API.swift
//
//  Created by Ulrich Vormbrock on 03/04/18.
//  Copyright © 2018 Ulrich Vormbrock. All rights reserved.
//

import UIKit

class API {
    static let host = "http://www.freiwasser.blog/spielwiese/json/"

    struct Name {
        static let workout = "workouts2.json"
        static let plan = "trainingsplan.json"
    }
    
    enum HttpMethod: String {
        case POST = "POST"
        case GET = "GET"
        case PUT = "PUT"
    }
    
    struct statusCodes {
        static let INVALID_ACCESS_TOKEN = 401
        static let BAD_REQUEST = 400
        static let UNAUTHORIZED_ACCESS = 401
        static let SHOW_MESSAGE = 201
        static let SHOW_DATA = 200
        static let SLOW_INTERNET_CONNECTION = 999
    }
}

struct AlertMessage {
    static let SERVER_NOT_RESPONDING = "Something went wrong while connecting to server!"
    static let NO_INTERNET_CONNECTION = "Unable to connect with the server. Check your internet connection and try again."
    static let NO_DATA_CHANGED = "Server data don't need to be fetched."
}

