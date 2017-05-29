//
//  ResourceOwnerPasswordCredentialsGrantFlow.swift
//  MHIdentityKit
//
//  Created by Milen Halachev on 4/12/17.
//  Copyright © 2017 Milen Halachev. All rights reserved.
//

import Foundation

//https://tools.ietf.org/html/rfc6749#section-1.3.3
//https://tools.ietf.org/html/rfc6749#section-4.3
public class ResourceOwnerPasswordCredentialsGrantFlow: AuthorizationGrantFlow {
    
    public let tokenEndpoint: URL
    public let credentialsProvider: CredentialsProvider
    public let scope: Scope?
    public let networkClient: NetworkClient
    public let storage: IdentityStorage
    public let clientAuthorizer: RequestAuthorizer
    
    public private(set) var accessTokenResponse: AccessTokenResponse? {
        
        didSet {
            
            self.refreshToken = self.accessTokenResponse?.refreshToken
        }
    }
    
    private static let refreshTokenKey = Bundle(for: ResourceOwnerPasswordCredentialsGrantFlow.self).bundleIdentifier! + ".refreshToken"
    private var refreshToken: String? {
        
        get {
            
            return self.storage.value(forKey: type(of: self).refreshTokenKey)
        }
        
        set {
            
            self.storage.set(newValue, forKey: type(of: self).refreshTokenKey)
        }
    }
    
    private var canRefreshAccessToken: Bool {
        
        return self.refreshToken != nil
    }
    
    //MARK: - Init
    
    public init(tokenEndpoint: URL, credentialsProvider: CredentialsProvider, scope: Scope? = nil, networkClient: NetworkClient = DefaultNetoworkClient(), storage: IdentityStorage, clientAuthorizer: RequestAuthorizer) {
        
        self.tokenEndpoint = tokenEndpoint
        self.credentialsProvider = credentialsProvider
        self.scope = scope
        
        self.networkClient = networkClient
        self.storage = storage
        self.clientAuthorizer = clientAuthorizer
    }
    
    public convenience init(tokenEndpoint: URL, clientID: String, secret: String, username: String, password: String, scope: Scope? = nil, storage: IdentityStorage) {
        
        self.init(tokenEndpoint: tokenEndpoint, credentialsProvider: DefaultCredentialsProvider(username: username, password: password), scope: scope, storage: storage, clientAuthorizer: ClientHTTPBasicAuthorizer(clientID: clientID, secret: secret))
    }
    
    //MARK: - AuthorizationGrantFlow
    
    public func authenticate(handler: @escaping (AccessTokenResponse?, Error?) -> Void) {
        
        self.credentialsProvider.credentials { [unowned self] (username, password) in
            
            //build the request
            var request = URLRequest(url: self.tokenEndpoint)
            request.httpMethod = "POST"
            request.httpBody = AccessTokenRequest(username: username, password: password, scope: self.scope).dictionary.urlEncodedParametersData
            
            self.clientAuthorizer.authorize(request: request, handler: { (request, error) in
                
                guard error == nil else {
                    
                    handler(nil, error)
                    return
                }
                
                //perform the request
                self.networkClient.perform(request: request, handler: { (data, response, error) in
                    
                    do {
                        
                        //if there is an error - throw it
                        if let error = error {
                            
                            throw error
                        }
                        
                        //if response is unknown - throw an error
                        guard let response = response as? HTTPURLResponse else {
                            
                            throw MHIdentityKitError.authenticationFailed(reason: .unknownURLResponse)
                        }
                        
                        //parse the data
                        guard
                        let data = data,
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        else {
                            
                            throw MHIdentityKitError.authenticationFailed(reason: .unableToParseAccessToken)
                        }
                        
                        //if the error is one of the defined in the OAuth2 framework - throw it
                        if let error = ErrorResponse(json: json) {
                            
                            throw error
                        }
                        
                        //make sure the response code is success 2xx
                        guard (200..<300).contains(response.statusCode) else {
                            
                            throw MHIdentityKitError.authenticationFailed(reason: .unknownHTTPResponse(code: response.statusCode))
                        }
                        
                        //parse the access token
                        let accessTokenResponse = AccessTokenResponse(json: json)
                        
                        DispatchQueue.main.async {
                            
                            handler(accessTokenResponse, nil)
                        }
                    }
                    catch {
                        
                        DispatchQueue.main.async {
                            
                            handler(nil, error)
                        }
                    }
                })
            })
            
            
        }
    }
}

//MARK: - Models

extension ResourceOwnerPasswordCredentialsGrantFlow {
    
    //https://tools.ietf.org/html/rfc6749#section-4.3.2
    fileprivate struct AccessTokenRequest {
        
        let grantType: GrantType = .password
        let username: String
        let password: String
        let scope: Scope?
        
        var dictionary: [String: Any] {
            
            var dictionary = [String: Any]()
            dictionary["grant_type"] = self.grantType.rawValue
            dictionary["username"] = self.username
            dictionary["password"] = self.password
            dictionary["scope"] = self.scope?.value
            
            return dictionary
        }
    }
    
    
}
