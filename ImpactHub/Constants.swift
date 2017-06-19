//
//  Constants.swift
//  WAYW
//
//  Created by Niklas Alvaeus on 02/09/2016.
//  Copyright © 2016 Gravity Not Applicable Limited. All rights reserved.
//

import Foundation
import UIKit
import SalesforceSDKCore

enum Result<T> {
    case Success(T)
    case Failure(Error)
}

enum MyError : Error {
    case Error(String)
    case JSONError
}

struct Constants {

    // Dev
    static let host = "community-impacthub.cs88.force.com/login?so=00D9E000000DCFw"
    static var communityId : String {
        get {
            return SFUserAccountManager.sharedInstance().currentUser!.communityId!
        }
    }
    
    
    
}


