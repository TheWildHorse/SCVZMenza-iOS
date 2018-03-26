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

extension DataRequest {
    static func responseMenusArray() -> DataResponseSerializer<Array<MenusWrapper>> {
        return DataResponseSerializer { request, response, data, error in
            guard error == nil else {
                return .failure(error!)
            }
            
            let JSONResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)
            
            switch result {
            case .success(let value):
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
                
                return .success(wrappers)
            case .failure(let error):
                return .failure(error)
            }
        }
    }
    
    @discardableResult
    func responseMenuWrappers(
        queue: DispatchQueue? = nil,
        completionHandler: @escaping (DataResponse<Array<MenusWrapper>>) -> Void)
        -> Self
    {
        return response(
            queue: queue,
            responseSerializer: DataRequest.responseMenusArray(),
            completionHandler: completionHandler
        )
    }
}


class MenusFetcherService {
    
    class func endpoint() -> String {
        return "https://rinkovec.com/menza/"
    }
    
    private class func getMenusAtPath(completionHandler: @escaping (Array<MenusWrapper>?, NSError?) -> Void) {
        Alamofire.request(MenusFetcherService.endpoint())
            .responseMenuWrappers { (response) in
                completionHandler(response.result.value, response.result.error as NSError?)
        }
    }
    
    class func getMenus(completionHandler: @escaping (Array<MenusWrapper>?, NSError?) -> Void) {
        getMenusAtPath(completionHandler: completionHandler)
    }
    
}
