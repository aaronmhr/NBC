//
//  URLSessionExtension.swift
//  Networking
//
//  Created by Aaron Huánuco on 13/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Foundation

extension URLSession: URLSessionProtocol {
    public func makeRequest(for url: URL, completion: @escaping (RemoteResult) -> Void) -> URLSessionDataTask? {
        return dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else if let response = response, let data = data {
                    completion(.success((response, data)))
                } else {
                    let error = NSError(domain: "Unidentified Error at \(#file)", code: 0, userInfo: nil)
                    completion(.failure(error))
                }
                
            }
        }
    }
}
