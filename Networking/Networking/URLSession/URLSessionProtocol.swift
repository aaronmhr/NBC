//
//  URLSessionProtocol.swift
//  Networking
//
//  Created by Aaron Huánuco on 14/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Foundation

public protocol URLSessionProtocol {
    typealias RemoteResult = Result<(URLResponse, Data), Error>
    
    func makeRequest(for url: URL, completion: @escaping (RemoteResult) -> Void) -> URLSessionDataTask?
}
