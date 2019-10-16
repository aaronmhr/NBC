//
//  DefaultNetworkingDependencies.swift
//  N26BC
//
//  Created by Aaron Huánuco on 15/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Networking

final class DefaultNetworkingDependencies: NetworkingDependenciesProtocol {
    lazy var session = URLSession(configuration: .default)
    lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    lazy var apiService: URLSessionClientProtocol = URLSessionClient(session: session, decoder: decoder)
}
