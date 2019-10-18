//
//  URLSessionClient.swift
//  Networking
//
//  Created by Aaron Huánuco on 13/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Foundation

public final class URLSessionClient: URLSessionClientProtocol {
    private let session: URLSessionProtocol
    private let decoder: JSONDecoder
    
    public init(session: URLSessionProtocol, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }
    
    public func fetchResources<T: Decodable>(url: URL?, completion: @escaping (Result<T, NetworkingError>) -> Void) {
        guard let url = url else {
            completion(.failure(.couldNotBuildURL))
            return
        }
        
        session.makeRequest(for: url) { result in
            switch result {
            case .success(let (response, data)):
                guard let response = response as? HTTPURLResponse else {
                    completion(.failure(.invalidResponse))
                    return
                }
                checkSuccessCase(response: response, data: data, completion: completion)
            case .failure(let error):
                completion(.failure(.other(error.localizedDescription)))
            }
            }?.resume()
        
        func checkSuccessCase<T: Decodable>(response: HTTPURLResponse, data: Data, completion: @escaping (Result<T, NetworkingError>) -> Void) {
            let statusCode = response.statusCode
            switch statusCode {
            case 200...299:
                do {
                    let values = try self.decoder.decode(T.self, from: data)
                    completion(.success(values))
                } catch {
                    completion(.failure(.decodingError))
                }
            case 400...499:
                completion(.failure(.clientError("\(statusCode)")))
            case 500...599:
                completion(.failure(.serverError("\(statusCode)")))
            default:
                completion(.failure(.other("\(statusCode)")))
            }
        }
    }
}
