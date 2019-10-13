//
//  URLSessionExtension.swift
//  Networking
//
//  Created by Aaron Huánuco on 13/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Foundation

typealias RemoteResult = Result<(URLResponse, Data), Error>

extension URLSession {
    func dataTask(with url: URL, result: @escaping (RemoteResult) -> Void) -> URLSessionDataTask {
        return dataTask(with: url) { (data, response, error) in
            if let error = error {
                result(.failure(error))
            } else if let response = response, let data = data {
                result(.success((response, data)))
            } else {
                let error = NSError(domain: "Unidentified Error at \(#file)", code: 0, userInfo: nil)
                result(.failure(error))
            }
        }
    }
}
