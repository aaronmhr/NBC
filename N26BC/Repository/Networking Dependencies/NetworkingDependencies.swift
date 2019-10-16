//
//  NetworkingDependencies.swift
//  N26BC
//
//  Created by Aaron Huánuco on 15/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Networking

protocol NetworkingDependenciesProtocol {
    var apiService: URLSessionClientProtocol { get }
}
