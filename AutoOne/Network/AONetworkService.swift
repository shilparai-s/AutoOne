//
//  AONetworkService.swift
//  AutoOne
//
//  Created by Shilpa S on 18/11/19.
//  Copyright © 2019 Shilpa S. All rights reserved.
//

import Foundation
import Alamofire

class AONetworkService {
    
    class func startService(with request : URLRequest, onCompletion handler : (([String : Any]?,Error?) -> ())?) {
        Alamofire.request(request).responseData(completionHandler: {
            dataResponse in
            if dataResponse.result.isSuccess {
                if let data = dataResponse.data {
                     do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : Any] {
                            handler?(json,nil)
                        }
                     }
                     catch {
                        handler?(nil,error)
                     }
                 }
            }
            else {
                handler?(nil,dataResponse.error)
            }
         })
    }
}
