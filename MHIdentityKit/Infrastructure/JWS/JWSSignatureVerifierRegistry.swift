//
//  JWSSignatureVerifierRegistry.swift
//  MHIdentityKit
//
//  Created by Milen Halachev on 27.08.19.
//  Copyright © 2019 Milen Halachev. All rights reserved.
//

import Foundation

///A JWSSignatureVerifier which contains multiple registered JWSSignatureVerifierProvider and resolves and verifires a JWT using a concrete JWSSignatureVerifier.
public class JWSSignatureVerifierRegistry: JWSSignatureVerifier {
    
    public var providers: [JWSSignatureVerifierProvider] = []
    
    public init() {
        
    }
    
    public func register(provider: JWSSignatureVerifierProvider) {
        
        self.providers.append(provider)
    }
    
    public func verify(token: JWT) throws {
        
        guard let verifier = self.providers.compactMap({ $0.provideSignatureVerifier(for: token) }).first else {
            
            throw Error.unableToFindProviderForToken
        }
        
        try verifier.verify(token: token)
    }
    
    public static let `default`: JWSSignatureVerifierRegistry = JWSSignatureVerifierRegistry()
}

extension JWSSignatureVerifierRegistry {
    
    enum Error: Swift.Error {
        
        ///Indicates that no provider was found for the given token
        case unableToFindProviderForToken
    }
}
