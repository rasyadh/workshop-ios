//
//  Apify.swift
//  workshop
//
//  Created by Twiscode on 21/07/20.
//  Copyright © 2020 rasyadh. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import SwiftyJSON

/**
 RequestCode Identifier for each api endpoint.
 */
enum RequestCode {
    case authLogin
}

/**
 Networking class to handle api networking request.
 */
class Apify: NSObject {
    static let shared = Apify()
    var prevOperationData: [String: Any]?
    
    let API_BASE_URL = "http://127.0.0.1/api"
    let API_AUTH_LOGIN = "/login"
    
    
    // MARK: - Basic Networking Functions
    
    /**
     Create headers for http request.
     - Parameters:
        - withAuthorization: Bool indicate usage of Authorization in headers
        - withXApiKey: Bool indicate usage of X-Api-Key in headers
        - accept: String indicate defined Accept in headers, default set to application/json
     - Returns: Map of headers value
     */
    fileprivate func getHeaders(withAuthorization: Bool, accept: String? = nil) -> HTTPHeaders {
        var headers: HTTPHeaders = HTTPHeaders()
        
        // Assign accept properties
        if accept == nil { headers["Accept"] = "application/json" }
        else { headers["Accept"] = accept }
        
        // Asign authorization properties
        if withAuthorization {
            if let token = UserDefaults.standard.string(forKey: Preferences.tokenLogin) {
                headers["Authorization"] = "Bearer \(token)"
            }
        }
        
        return headers
    }
    
    /**
     Save request data in case if request is failed due to expired token.
     - Parameters:
        - url: String url endpoint API
        - method: HTTPMethod used for request
        - parameters: Body used for the request
        - headers: Headers used for the request
        - code: RequestCode identifier
     - Returns: Map of requestData
     */
    private func setRequestData(_ url: String, method: HTTPMethod, parameters: [String: String]?, headers: HTTPHeaders?, code: RequestCode) -> [String: Any] {
        var requestData = [
            "url": url,
            "method": method,
            "code": code
            ] as [String: Any]
        
        if parameters != nil { requestData["parameters"] = parameters }
        if headers != nil { requestData["headers"] = headers }
        
        return requestData
    }
    
    /**
     Asynchronous networking http request.
     - Parameters:
        - url: String url endpoint API
        - method: HTTPMethod used for request
        - parameters: Body used for the request
        - headers: Headers used for the request
        - code: RequestCode identifier
     */
    private func request(_ url: String, method: HTTPMethod, parameters: [String: String]?, headers: HTTPHeaders?, code: RequestCode) {
        let _ = setRequestData(url, method: method, parameters: parameters, headers: headers, code: code)
        
        // Perform request
        AF.request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers,
                   interceptor: nil, requestModifier: nil).validate().responseJSON { response in
                
                switch response.result {
                case .success:
                    print("[ Success ] Request Code: \(code)")
                    print("[ Success ] Status Code: \(response.response!.statusCode)")
                    
                    // URL parsing or pre-delivery functions goes here
                    let responseJSON = try! JSON(data: response.data!)
                    var addData: [String: Any]? = response.data == nil ? nil : ["json": responseJSON["data"]]
                    if !responseJSON["meta"].isEmpty {
                        addData!["meta"] = responseJSON["meta"]
                    }
                    self.consolidation(code, success: true, additionalData: addData)
                case .failure:
                    // Request error parsing
                    print("[ Failed ] Request Code : \(code)")
                    print("[ Error ] : Error when executing API operation : \(code) ! Details :\n" + (response.error?.localizedDescription)!)
                    print("[ ERROR ] : URL : " + (response.request!.url!.absoluteString))
                    print("[ ERROR ] : Headers : %@", response.request?.allHTTPHeaderFields as Any)
                    print("[ ERROR ] : Result : %@", response.value as Any)
                    
                    let statusCode = response.response?.statusCode
                    print("[ Failed ] Status Code: \(String(describing: statusCode))")
                    
                    if var json = JSON(rawValue: response.data as Any) {
                        if json["message"].stringValue == "Unauthenticated." || statusCode == 401 {
                            json["expired"] = true
                            print("[ ERROR ] Error JSON : \(json)")
                            self.consolidation(code, success: false, additionalData: ["json": json])
                        }
                        print("[ ERROR ] Error JSON : \(json)")
                        self.consolidation(code, success: false, additionalData: ["json": json])
                        return
                    } else {
                        self.consolidation(code, success: false)
                        return
                    }
                }
        }
    }
    
    /**
     Asynchronous networking http request.
     - Parameters:
        - url: String url endpoint API
        - method: HTTPMethod used for request
        - parameters: Body used for the request
        - headers: Headers used for the request
        - code: RequestCode identifier
     */
    private func request(_ url: String, method: HTTPMethod, parameters: [String: Any]?, headers: HTTPHeaders?, code: RequestCode) {
        // Perform request
        AF.request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers,
                   interceptor: nil, requestModifier: nil).validate().responseJSON { response in
                
                switch response.result {
                case .success:
                    print("[ Success ] Request Code: \(code)")
                    print("[ Success ] Status Code: \(response.response!.statusCode)")
                    
                    // URL parsing or pre-delivery functions goes here
                    let responseJSON = try! JSON(data: response.data!)
                    var addData: [String: Any]? = response.data == nil ? nil : ["json": responseJSON["data"]]
                    
                    if !responseJSON["meta"].isEmpty {
                        addData!["meta"] = responseJSON["meta"]
                    }
                    
                    self.consolidation(code, success: true, additionalData: addData)
                case .failure:
                    // Request error parsing
                    print("[ Failed ] Request Code : \(code)")
                    print("[ Error ] : Error when executing API operation : \(code) ! Details :\n" + (response.error?.localizedDescription)!)
                    print("[ ERROR ] : URL : " + (response.request!.url!.absoluteString))
                    print("[ ERROR ] : Headers : %@", response.request?.allHTTPHeaderFields as Any)
                    print("[ ERROR ] : Result : %@", response.value as Any)
                    
                    let statusCode = response.response?.statusCode
                    print("[ Failed ] Status Code: \(String(describing: statusCode))")
                    
                    if var json = JSON(rawValue: response.data as Any) {
                        if json["message"].stringValue == "Unauthenticated." {
                            json["expired"] = true
                            print("[ ERROR ] Error JSON : \(json)")
                            self.consolidation(code, success: false, additionalData: ["json": json])
                        }
                        print("[ ERROR ] Error JSON : \(json)")
                        self.consolidation(code, success: false, additionalData: ["json": json])
                        return
                    } else {
                        self.consolidation(code, success: false)
                        return
                    }
                }
        }
    }
    
    /**
     Asynchronous networking http multipart form request. Used for uploading image file.
     - Parameters:
        - url: String url endpoint API
        - method: HTTPMethod used for request
        - parameters: Body used for the upload
        - imageParameters: Body contain image file used for the upload
        - headers: Headers used for the request
        - code: RequestCode identifier
     */
    private func uploadRequest(_ url: String, method: HTTPMethod, parameters: [String: String]?, imageParameters: [String: Any]?, headers: HTTPHeaders?, code: RequestCode) {
        // perform multipart request
        AF.upload(multipartFormData: { (multipartFormData) in
            if let imageParameters = imageParameters {
                guard let imageParam = imageParameters["image"] else { return }
                guard let imageName = imageParameters["name"] else { return }
                guard let imageFieldName = imageParameters["field_name"] else { return }
                
                if let imageSize = (imageParam as! UIImage).jpegData(compressionQuality: 1)?.count {
                    let imageData = self.compressImageBySize(imageSize: Double(imageSize), image: (imageParam as! UIImage))
                    let imageName = "\(String(describing: imageName)).jpg"
                    multipartFormData.append(imageData!, withName: imageFieldName as! String, fileName: imageName, mimeType: "image/jpeg")
                }
            }
            
            if let parameters = parameters {
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            }
        }, to: url, method: method, headers: headers).uploadProgress(queue: .main, closure: { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        }).responseJSON(completionHandler: { data in
            print("upload finished: \(data)")
        }).response { (response) in
            switch response.result {
            case .success:
                print("[ SUCCESS ] Request Code : \(code)")
                print("[ SUCCESS ] Status Code: \(String(describing: response.response?.statusCode))")
                
                // URL parsing or pre-delivery functions goes here
                let responseJSON = try! JSON(data: response.data!)
                
                if !responseJSON["errors"].dictionaryValue.isEmpty {
                    self.consolidation(code, success: false, additionalData: ["json": JSON(rawValue: response.data as Any)!])
                } else {
                    var addData: [String: Any]? = response.data == nil ? nil : ["json": responseJSON["data"]]
                    
                    if !responseJSON["meta"].isEmpty {
                        addData!["meta"] = responseJSON["meta"]
                    }
                    self.consolidation(code, success: true, additionalData: addData)
                }
            case .failure:
                print("[ Failed ] Request Code : \(code)")
                print("[ Failed ] Status Code: \(String(describing: response.response?.statusCode))")
                print("[ Error ] : Error when executing API operation : \(code) ! Details :\n" + (response.error?.localizedDescription)!)
                print("[ ERROR ] : URL : " + (response.request!.url!.absoluteString))
                print("[ ERROR ] : Headers : %@", response.request?.allHTTPHeaderFields as Any)
                print("[ ERROR ] : Result : %@", response.value as Any)
                
                // Request Error Handling here
                if let json = JSON.init(rawValue: response.data as Any) {
                    print("[ ERROR ] Error JSON : \(json)")
                    self.consolidation(code, success: false, additionalData: ["json" : json])
                } else {
                    self.consolidation(code, success: false)
                }
            }
        }
    }
    
    /**
     Compress image quality berfore upload.
     - Parameters:
        - imageSize: Double indicate image file size
        - image: UIImage of image that would be compressed
     - Returns: Data of compressed image
     */
    func compressImageBySize(imageSize: Double, image: UIImage) -> Data? {
        if imageSize / 1024 > 7168.0 {
            return image.compressImage(.lowest)
        }
        else if imageSize / 1024 < 7168.0 && imageSize / 1024 > 5120.0 {
            return image.compressImage(.low)
        }
        else if imageSize / 1024 < 5120.0 && imageSize / 1024 > 3072.0 {
            return image.compressImage(.medium)
        }
        else if imageSize / 1024 < 3072.0 && imageSize / 1024 > 1024.0 {
            return image.compressImage(.high)
        }
        else if imageSize / 1024 < 1024.0 && imageSize / 1024 > 0.0 {
            return image.compressImage(.highest)
        }
        else {
            return nil
        }
    }
    
    /**
     Handle parsing response JSON to standard format.
     - Parameters:
        - requestCode: RequestCode identifier
        - success: Bool indicating request status
        - additionalData: JSON Data
     */
    private func consolidation(_ requestCode: RequestCode, success: Bool, additionalData: [String: Any]? = nil) {
        var dict = [String: Any]()
        dict["success"] = success
        
        if additionalData != nil {
            for (key, value) in additionalData! {
                dict[key] = value
            }
            
            if !success && dict["json"] != nil {
                if let json = dict["json"] as? JSON {
                    if let error = json["error"].string {
                        dict["error"] = error
                    }
                    
                    if let message = json["message"].string {
                        dict["message"] = message
                    }
                    
                    if let expired = json["expired"].bool {
                        dict["expired"] = expired
                    }
                    
                    if let kicked = json["kicked"].bool {
                        dict["kicked"] = kicked
                    }
                }
            }
        }
        
        switch requestCode {
        // Authentication
        case .authLogin:
            if success { Storify.shared.handleSuccessfullLogin(dict["json"] as! JSON, dict["meta"] as! JSON) }
            else { Notify.post(name: NotifName.authLogin, sender: self, userInfo: dict) }
        }
    }
    
    // MARK: - Auth
    func login(parameters: [String: String]) {
        let URL = API_BASE_URL + API_AUTH_LOGIN
        
        request(
            URL,
            method: .post,
            parameters: parameters,
            headers: getHeaders(withAuthorization: false),
            code: .authLogin)
    }
}
