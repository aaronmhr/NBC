//
//  URLSessionClientProtocol.swift
//  Networking
//
//  Created by Aaron Huánuco on 13/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Foundation

public protocol URLSessionClientProtocol {
    func fetchResources<T: Decodable>(url: URL?, completion: @escaping (Result<T, NetworkingError>) -> Void)
}
