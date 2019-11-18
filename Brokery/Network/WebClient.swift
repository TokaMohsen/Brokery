//
//  WebClient.swift
//  Brokery
//
//  Created by ToqaMohsen on 11/18/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import Foundation
import Reachability
import UICKeyChainStore

enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}


final class WebClient {
    private var baseUrl: String
    
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    typealias JSON = [String: Any]

    func load(path: String, method: RequestMethod, params: JSON, completion: @escaping (Any?, ServiceError?) -> ()) -> URLSessionDataTask? {
        // Checking internet connection availability
        if !Reachability.forInternetConnection().isReachable() {
            completion(nil, ServiceError.noInternetConnection)
            return nil
        }
        
        
        // Adding common parameters
//        var parameters = params
//        if let token =  UICKeyChainStore.string(forKey: "application_token") {
//            parameters["token"] = token
//        }
        
        
        
        
        // Creating the URLRequest object
        let request = URLRequest(baseUrl: baseUrl, path: path, method: method, params: params)
        
        
        
        
        // Sending request to the server.
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Parsing incoming data
            var object: Any? = nil
            if let data = data {
                object = try? JSONSerialization.jsonObject(with: data, options: [])
            }
            
            if let httpResponse = response as? HTTPURLResponse, (200..<300) ~= httpResponse.statusCode {
                completion(object, nil)
            } else {
                let error = (object as? JSON).flatMap(ServiceError.init) ?? ServiceError.other
                completion(nil, error)
            }
        }
        
        task.resume()
        
        return task
    }
  
}
extension URL {
    typealias JSON = [String: Any]

    init(baseUrl: String, path: String, params: JSON, method: RequestMethod) {
        var components = URLComponents(string: baseUrl)!
        components.path += path
        
        switch method {
        case .get:
            components.queryItems = params.map {
                URLQueryItem(name: $0.key, value: String(describing: $0.value))
            }
        default:
            break
        }
        
        self = components.url!
    }
}

extension URLRequest {
    typealias JSON = [String: Any]

    init(baseUrl: String, path: String, method: RequestMethod, params: JSON) {
        let url = URL(baseUrl: baseUrl, path: path, params: params, method: method)
        self.init(url: url)
        httpMethod = method.rawValue
        setValue("application/json", forHTTPHeaderField: "Accept")
        setValue("application/json", forHTTPHeaderField: "Content-Type")
        switch method {
        case .post, .put:
            httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        default:
            break
        }
    }
}
