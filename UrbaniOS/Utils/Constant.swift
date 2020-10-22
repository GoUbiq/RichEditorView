//
//  Constant.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-09-28.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit

enum Environment {
    case localDebug
    case remoteDebug
    case production
    
    var associatedPlistFileName: String {
        switch self {
        case .localDebug:
            return "devSettings"
        case .remoteDebug:
            return "devSettings"
        case .production:
            return "devSettings"
        }
    }
    
    var anonymousTopic: String {
        switch self {
        case .localDebug, .remoteDebug:
            return "anonymous_development"
        case .production:
            return "anonymous_production"
        }
    }
    
    var homePageBarTitle: String {
        switch self {
        case .localDebug:
            return "ST Local"
        case .remoteDebug:
            return "ST Staging"
        case .production:
            return "Shop Together"
        }
    }
}

let userDefaults = UserDefaults.standard

#if LOCAL
    var devEnvironment: Environment = .localDebug
#elseif DEBUG
    var devEnvironment: Environment = .remoteDebug
#else
    var devEnvironment: Environment = .production
#endif

func localized(_ key: String, comment: String = "") -> String {
    return NSLocalizedString(key, comment: "")
}

//MARK: - userDefaults keys
let apiAccessHostUrl = "hostUrl"
let webSocketUrl = "socketUrl"
let stripeKeyKey = "stripeKey"

//MARK: - Storyboards
let cameraStoryboard = UIStoryboard(name: "Camera", bundle: nil)
let templateStoryboard = UIStoryboard(name: "Template", bundle: nil)
let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
let postStoryboard = UIStoryboard(name: "Post", bundle: nil)

