//
//  AONetworkManager.swift
//  AutoOne
//
//  Created by Shilpa S on 18/11/19.
//  Copyright © 2019 Shilpa S. All rights reserved.
//

import Foundation

class AONetworkRouter {
    
    let baseURL : String = "api-aws-eu-qa-1.auto1-test.com​"
    
    let authorisationKey = "wa_key=coding-puzzle-client-449cc9d"
    
    enum RequestURL : String {
        case manufacturer = "/v1/car-types/manufacturer"
        case models = "/v1/car-types/main-types"
    }
        
    static var shared : AONetworkRouter = {
        let mgr = AONetworkRouter()
        return mgr
    }()
    
    private init() {
        
    }
    
    func manufacturerRequest(with page : Int, pageSize : Int) -> URLRequest {
                
        var urlComponet = URLComponents()
        urlComponet.scheme = "http"
        urlComponet.host = baseURL
        urlComponet.path = RequestURL.manufacturer.rawValue
        urlComponet.queryItems = [URLQueryItem(name: "page", value: "\(page)"),URLQueryItem(name: "pageSize", value: "\(pageSize)"),URLQueryItem(name: "wa_key", value: "coding-puzzle-client-449cc9d")]
        return URLRequest(url: urlComponet.url!)
    }
    
    func modelRequest(for manufacturer : String, page : Int, pageSize : Int) -> URLRequest {
        var urlComponet = URLComponents()
        urlComponet.scheme = "http"
        urlComponet.host = baseURL
        urlComponet.path = RequestURL.models.rawValue
        urlComponet.queryItems = [URLQueryItem(name: "manufacturer", value: manufacturer),URLQueryItem(name: "page", value: "\(page)"),URLQueryItem(name: "pageSize", value: "\(pageSize)"),URLQueryItem(name: "wa_key", value: "coding-puzzle-client-449cc9d")]
        return URLRequest(url: urlComponet.url!)
    }
    
    
}
