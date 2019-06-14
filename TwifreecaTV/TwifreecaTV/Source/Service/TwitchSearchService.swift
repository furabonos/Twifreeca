//
//  TwitchSearchService.swift
//  TwifreecaTV
//
//  Created by Euijae Hong on 12/06/2019.
//  Copyright © 2019 엄태형. All rights reserved.
//

import Foundation
import Alamofire

protocol TwitchSearchType {
    func searchTwitchStreamer(name: String, completion: @escaping(Result<TwitchSearch>) -> ())
    func searchTwitchVideos(name: String, completion: @escaping(Result<TwitchVideo>) -> ())
}

struct TwitchSearchService: TwitchSearchType {
    
    static let manager: Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "ffffff")
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60
        configuration.httpCookieStorage = HTTPCookieStorage.shared
        configuration.urlCache = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
        let manager = Alamofire.SessionManager(configuration: configuration)
        return manager
    }()
    
    func searchTwitchStreamer(name: String, completion: @escaping (Result<TwitchSearch>) -> ()) {
        
        var headers = [String: String]()
        headers.updateValue("gp6ddqo2btpzj4krg78e3i75blsnpw", forKey: "Client-ID")
        
        var parameters = [String: String]()
        parameters.updateValue(name, forKey: "login")
        
        AfreecaSearchService.manager.request(API.Twitch.twitchSearchURL, method: .get, parameters: parameters, headers: headers)
            .validate().responseData{ response in
                switch response.result{
                case .success(let value):
                    do {
                        let decodableValue = try JSONDecoder().decode(TwitchSearch.self, from: value)
                        completion(Result.success(decodableValue))
                    }catch {
                        
                    }
                case .failure(let error):
                    print("error = \(error)")
                    completion(.failure(nil, error))
                }
        }
    }
    
    func searchTwitchVideos(name: String, completion: @escaping (Result<TwitchVideo>) -> ()) {
        
        var headers = [String: String]()
        headers.updateValue("gp6ddqo2btpzj4krg78e3i75blsnpw", forKey: "Client-ID")
        
        var parameters = [String: String]()
        parameters.updateValue(name, forKey: "user_id")
        parameters.updateValue("3", forKey: "first")
        
        AfreecaSearchService.manager.request(API.Twitch.twitchVideoURL, method: .get, parameters: parameters, headers: headers)
            .validate().responseData{ response in
                switch response.result{
                case .success(let value):
                    do {
                        let decodableValue = try JSONDecoder().decode(TwitchVideo.self, from: value)
                        completion(Result.success(decodableValue))
                    }catch {
                        
                    }
                case .failure(let error):
                    print("error = \(error)")
                    completion(.failure(nil, error))
                }
        }
    }
    
//    func liveAfreecaBJ(name: String, completion: @escaping (Result<AfreecaLiveInfo>) -> ()) {
//        var parameters = [
//            "name": name
//        ]
//
//        AfreecaSearchService.manager.request(API.liveURL, method: .post, parameters: parameters)
//            .validate().responseData{ response in
//                switch response.result{
//                case .success(let value):
//                    do {
//                        //                        print("fdsfsdfds")
//                        let decodableValue = try JSONDecoder().decode(AfreecaLiveInfo.self, from: value)
//                        //                        print("aa = \(decodableValue)")
//                        completion(Result.success(decodableValue))
//                    }catch {
//
//                    }
//                case .failure(let error):
//                    print("error = \(error)")
//                    completion(.failure(nil, error))
//                }
//        }
//    }
}

