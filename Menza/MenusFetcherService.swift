//
//  MenusFetcherService.swift
//  Menza
//
//  Created by Igor Rinkovec on 06/06/16.
//  Copyright © 2016 Igor Rinkovec. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

extension Alamofire.Request {
    func responseMenusArray(completionHandler: Response<Array<MenusWrapper>, NSError> -> Void) -> Self {
        let responseSerializer = ResponseSerializer<Array<MenusWrapper>, NSError> { request, response, data, error in
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
                var wrappers = Array<MenusWrapper>()
                
                for (_, dayData) in json {
                    let wrapper = MenusWrapper()
                    wrapper.date = dayData["date"].stringValue
                    
                    // Get lunch
                    var lunch = [Menu]()
                    var results = dayData["menus"]["lunch"]
                    for jsonMenus in results
                    {
                        let menu = Menu(json: jsonMenus.1, id: Int(jsonMenus.0))
                        lunch.append(menu)
                    }
                    wrapper.lunch = lunch
                    
                    // Get dinner
                    var dinner = [Menu]()
                    results = dayData["menus"]["dinner"]
                    for jsonMenus in results
                    {
                        let menu = Menu(json: jsonMenus.1, id: Int(jsonMenus.0))
                        dinner.append(menu)
                    }
                    wrapper.dinner = dinner
                    
                    // Attach to list
                    wrappers.append(wrapper)
                }
                
                return .Success(wrappers)
            case .Failure(let error):
                return .Failure(error)
            }
        }
        
        return response(responseSerializer: responseSerializer,
                        completionHandler: completionHandler)
    }
}


class MenusFetcherService {
    
    class func endpoint() -> String {
        return "http://igor-rinkovec.from.hr/menza/"
    }
    
    private class func getMenusAtPath(completionHandler: (Array<MenusWrapper>?, NSError?) -> Void) {
        // iOS 9: Replace HTTP with HTTPS
        Alamofire.request(.GET, MenusFetcherService.endpoint())
            .responseMenusArray { response in
                completionHandler(response.result.value, response.result.error)
        }
    }
    
    class func getMenus(completionHandler: (Array<MenusWrapper>?, NSError?) -> Void) {
        getMenusAtPath(completionHandler)
    }
    
}