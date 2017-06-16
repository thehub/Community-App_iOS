//
//  Company.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 19/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Company {
    var id: String
    var name: String
    var type: String
    var photo: String
    var blurb: String
    var locationName: String
    var website: String?

}

extension Company {
    init?(json: JSON) {
        debugPrint(json)
        guard
            let id = json["Id"].string,
            let name = json["Name"].string
            else {
                return nil
        }
        self.id = id
        self.name = name
        
        self.type = "Full-time"
        self.photo = ""
        self.blurb = "sddsfsd"
        self.locationName = "Amsterdam"
        self.website = json["Website"].string
    }
    
}