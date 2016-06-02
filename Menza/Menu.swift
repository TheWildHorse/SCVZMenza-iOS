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

extension Alamofire.Request {
    func responseMenusArray(completionHandler: Response<MenusWrapper, NSError> -> Void) -> Self {
        let responseSerializer = ResponseSerializer<MenusWrapper, NSError> { request, response, data, error in
            guard error == nil else {
                return .Failure(error!)
            }
            guard let responseData = data else {
                let failureReason = "Array could not be serialized because input data was nil."
                let error = Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
                return .Failure(error)
            }
            
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, responseData, error)
            
            switch result {
            case .Success(let value):
                let json = SwiftyJSON.JSON(value)
                let wrapper = MenusWrapper()
                wrapper.date = json[0]["date"].stringValue
                
                // Get lunch
                var lunch = [Menu]()
                var results = json[0]["menus"]["lunch"]
                for jsonMenus in results
                {
                    let menu = Menu(json: jsonMenus.1, id: Int(jsonMenus.0))
                    lunch.append(menu)
                }
                wrapper.lunch = lunch
                
                // Get dinner
                var dinner = [Menu]()
                results = json[0]["menus"]["dinner"]
                for jsonMenus in results
                {
                    let menu = Menu(json: jsonMenus.1, id: Int(jsonMenus.0))
                    dinner.append(menu)
                }
                wrapper.dinner = dinner
                
                return .Success(wrapper)
            case .Failure(let error):
                return .Failure(error)
            }
        }
        
        return response(responseSerializer: responseSerializer,
                        completionHandler: completionHandler)
    }
}


class Menu {
    var id: Int?
    var name: String?
    var description: String?
    
    required init(json: JSON, id: Int?) {
        self.id = id
        self.name = json["name"].stringValue
        self.description = json["description"].stringValue
    }
    
    class func endpoint() -> String {
        return "http://igor-rinkovec.from.hr/menza/"
    }
    
    private class func getMenusAtPath(path: String, completionHandler: (MenusWrapper?, NSError?) -> Void) {
        // iOS 9: Replace HTTP with HTTPS
        Alamofire.request(.GET, path)
            .responseMenusArray { response in
                completionHandler(response.result.value, response.result.error)
        }
    }
    
    class func getMenus(completionHandler: (MenusWrapper?, NSError?) -> Void) {
        getMenusAtPath(Menu.endpoint(), completionHandler: completionHandler)
    }
    
}