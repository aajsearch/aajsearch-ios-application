//
//  APIManager.swift
//  YC_AI
//
//  Created by Geeta Manek on 14/09/24.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

class APIManager: NSObject {
    
    static var shared = APIManager()
    
    let uDID = UIDevice.current.identifierForVendor!.uuidString
    var Manager: Alamofire.Session = {
        let manager = ServerTrustManager(evaluators: ["your endpoint": DisabledTrustEvaluator()])
        let session = Session(serverTrustManager: manager)
        return session
    }()
    
        func MakePostAPICall(name:String, params:[String:Any], progress: Bool = true,  isUserIntrectionEnable : Bool = true, viewController: UIViewController? = nil, completionHandler: @escaping (NSDictionary?, String?, Int?)-> Void) {
            
            viewController?.view.isUserInteractionEnabled = isUserIntrectionEnable
//            if progress {
//                DispatchQueue.main.async {
//                    viewController?.showLoadingIndicator()
//                }
//            }
                
            let headers : HTTPHeaders = ["Accept": "application/json"]
        
        print("HEAD--------\(headers)")
        print("API--------\(name)")
        
        let base = BASE_URL
        let url = base + name
        
        AF.request(url, method: .post, parameters: params,encoding: JSONEncoding.default, headers: headers).responseData { response in
            viewController?.view.isUserInteractionEnabled = true

            switch response.result {
            case .success(let data):
                do {
                    let asJSON = try JSONSerialization.jsonObject(with: data)
                    if let asDic = asJSON as? NSDictionary{
                        _ = JSON(asDic)
                        completionHandler(asJSON as? NSDictionary, nil, response.response?.statusCode)
                    }
                    else{
                        completionHandler(asJSON as? NSDictionary, nil, response.response?.statusCode)
                    }
                } catch {
                    
                    print("I am error catch")
                    completionHandler(nil, JSON_VALIDATION, response.response?.statusCode)
                }
//                DispatchQueue.main.async {
//                    viewController?.hideLoadingIndicator()
//                }
            case .failure(_):
                print("I am error failure")
                completionHandler(nil, SERVER_VALIDATION, response.response?.statusCode)
            }
        }
    }
    
   
}

