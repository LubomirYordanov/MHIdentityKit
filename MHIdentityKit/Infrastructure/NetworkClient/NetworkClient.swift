//
//  NetworkClient.swift
//  MHIdentityKit
//
//  Created by Milen Halachev on 4/12/17.
//  Copyright © 2017 Milen Halachev. All rights reserved.
//

import Foundation

///A type that performs network requests
public protocol NetworkClient {
    
    ///Performs a request and execute a completion handler when it is done
    func perform(_ request: URLRequest, completion: @escaping @Sendable (NetworkResponse) -> Void)
}

extension NetworkClient {
    
    @available(iOS 13, tvOS 13, macOS 10.15, watchOS 6, *)
    public func perform(_ request: URLRequest) async -> NetworkResponse {
        
        return await withCheckedContinuation { continuation in
            
            self.perform(request) { response in
                
                continuation.resume(returning: response)
            }
        }
    }
}
