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
}

struct AfreecaSearchService: AfreecaSearchType {
    func searchAfreecaBJ(name: String, completion: @escaping (Result<AfreecaSearch>) -> ()) {
        var parameters = [
            "name": name
        ]
        
        Alamofire.request(API.URL, method: .post, parameters: parameters)
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
}
