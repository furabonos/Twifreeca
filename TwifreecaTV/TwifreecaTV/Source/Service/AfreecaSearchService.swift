//
//  AfreecaSearchService.swift
//  TwifreecaTV
//
//  Created by Euijae Hong on 22/05/2019.
//  Copyright © 2019 엄태형. All rights reserved.
//

import Foundation
import Alamofire

protocol AfreecaSearchType {
    func searchAfreecaBJ(name: String, completion: @escaping(Result<AfreecaSearch>) -> ())
    func liveAfreecaBJ(name: String, completion: @escaping(Result<AfreecaLiveInfo>) -> ())
}

struct AfreecaSearchService: AfreecaSearchType {
    
    static let manager: Alamofire.SessionManager = {
        
        let configuration = URLSessionConfiguration.background(withIdentifier: "ffffff")
        configuration.timeoutIntervalForRequest = 120
        configuration.timeoutIntervalForResource = 120
        configuration.httpCookieStorage = HTTPCookieStorage.shared
        configuration.urlCache = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
        let manager = Alamofire.SessionManager(configuration: configuration)
        return manager
    }()
    
    func searchAfreecaBJ(name: String, completion: @escaping (Result<AfreecaSearch>) -> ()) {
        var parameters = [
            "name": name
        ]
        
        TwitchSearchService.manager.request(API.searchURL, method: .post, parameters: parameters)
            .validate().responseData{ response in
                switch response.result{
                case .success(let value):
                    do {
//                        print("fdsfsdfds")
                        let decodableValue = try JSONDecoder().decode(AfreecaSearch.self, from: value)
//                        print("aa = \(decodableValue)")
                        completion(Result.success(decodableValue))
                    }catch {
                        
                    }
                case .failure(let error):
                    print("error = \(error)")
                    completion(.failure(nil, error))
                }
        }
    }
    
    func liveAfreecaBJ(name: String, completion: @escaping (Result<AfreecaLiveInfo>) -> ()) {
        var parameters = [
            "name": name
        ]
        
        TwitchSearchService.manager.request(API.liveURL, method: .post, parameters: parameters)
            .validate().responseData{ response in
                switch response.result{
                case .success(let value):
                    do {
                        //                        print("fdsfsdfds")
                        let decodableValue = try JSONDecoder().decode(AfreecaLiveInfo.self, from: value)
                        //                        print("aa = \(decodableValue)")
                        completion(Result.success(decodableValue))
                    }catch {
                        
                    }
                case .failure(let error):
                    print("error = \(error)")
                    completion(.failure(nil, error))
                }
        }
    }
}
