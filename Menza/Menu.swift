//
//  Menu.swift
//  Menza
//
//  Created by Igor Rinkovec on 08/05/16.
//  Copyright © 2016 Igor Rinkovec. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class Menu {
    var id: Int?
    var name: String?
    var description: String?
    
    required init(json: JSON, id: Int?) {
        self.id = id
        self.name = json["name"].stringValue
        self.description = json["description"].stringValue
    }
    
}