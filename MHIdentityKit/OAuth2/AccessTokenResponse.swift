//
//  AccessTokenResponse.swift
//  MHIdentityKit
//
//  Created by Milen Halachev on 5/24/17.
//  Copyright © 2017 Milen Halachev. All rights reserved.
//

import Foundation

//https://tools.ietf.org/html/rfc6749#section-5.1
public struct AccessTokenResponse {
    
    public var accessToken: String
    public var tokenType: String
    public var expiresIn: TimeInterval?
    public var refreshToken: String?
    public var scope: Scope?
    
    //Contains any additional parameters of the access token response.
    public var additionalParameters: [Parameter: Any]
    
    //Contains all parameteres, including additional
    public var parameters: [Parameter: Any] {
        
        var parameters: [Parameter: Any] = [:]
        parameters[.accessToken] = accessToken
        parameters[.tokenType] = tokenType
        parameters[.expiresIn] = expiresIn
        parameters[.refreshToken] = refreshToken
        parameters[.scope] = scope?.rawValue
        
        return parameters.merging(additionalParameters, uniquingKeysWith: { $1 })
    }
    
    ///Creates an instance of the receiver with the minimum requred parameters
    public init(accessToken: String, tokenType: String, expiresIn: TimeInterval?, refreshToken: String?, scope: Scope?) {
        
        self.accessToken = accessToken
        self.tokenType = tokenType
        self.expiresIn = expiresIn
        self.refreshToken = refreshToken
        self.scope = scope
        
        self.additionalParameters = [:]
    }
    
    ///Creates an instance of the receiver from a parameters dictionary.
    ///- throws: An error if required parameters are invalid or missing.
    public init(parameters: [Parameter: Any]) throws {
        
        var parameters = parameters
        
        guard let accessToken = parameters.removeValue(forKey: .accessToken) as? String else {
         
            throw Error.invalidAccessToken
        }
            
        guard let tokenType = parameters.removeValue(forKey: .tokenType) as? String else {
            
            throw Error.invalidTokenType
        }
        
        self.accessToken = accessToken
        self.tokenType = tokenType
        self.expiresIn = parameters.removeValue(forKey: Parameter.expiresIn) as? TimeInterval
        self.refreshToken = parameters.removeValue(forKey: Parameter.refreshToken) as? String
        
        if let scopeRawValue = parameters.removeValue(forKey: Parameter.scope) as? String {
        
            self.scope = Scope(rawValue: scopeRawValue)
        }
        else {
            
            self.scope = nil
        }
        
        self.additionalParameters = parameters
    }
    
    ///The date when this object has been created - used to determine whenever the access token has expired
    private var responseCreationDate = Date()
    
    ///determine whenever the access token has expired
    public var isExpired: Bool {
        
        //if expiration time interval is not provided - call the expiration handler
        guard let expiresIn = self.expiresIn else {
            
            return type(of: self).expirationHandler(self)
        }
        
        //compare the time interval since the creation of this object with the expiration time interval provided
        let timeIntervalPassed = Date().timeIntervalSince(self.responseCreationDate)
        return timeIntervalPassed >= expiresIn
    }
}

extension AccessTokenResponse {
    
    ///A type representing known parameters for the access token response
    public struct Parameter: RawRepresentable, Hashable, ExpressibleByStringLiteral, CustomStringConvertible {
        
        public var rawValue: String
        
        public init(rawValue: String) { self.rawValue = rawValue }
        public init(stringLiteral value: StringLiteralType) { self.init(rawValue: value) }
        
        public var description: String { rawValue }
        
        public static let accessToken: Self = "access_token"
        public static let tokenType: Self = "token_type"
        public static let expiresIn: Self = "expires_in"
        public static let refreshToken: Self = "refresh_token"
        public static let scope: Self = "scope"
    }
}

extension AccessTokenResponse {
    
    ///Provide a custom expiration handler in case the server does not return the expiration time interval.
    ///-returns: true if the token is expired, otherwise false. Default behaviour returns false.
    public static var expirationHandler: (AccessTokenResponse) -> Bool = { _ in
        
        //the authorization server SHOULD provide the expiration time via other means or document the default value.
        //Assume the token has not expired. In case it is - the failure of the request will indicate that the token is invalid, that should result in retry from client perspective.
        return false
    }
}

extension AccessTokenResponse {
    
    //https://tools.ietf.org/html/rfc6749#section-5.1
    //https://tools.ietf.org/html/rfc6749#section-5.2
    
    ///Creates an instance of the receiver from a `NetworkResponse`
    ///Handles an HTTP response in attempt to produce an access token or error
    ///- throws: An error if the creation fails
    public init(from networkResponse: NetworkResponse) throws {
        
        //if response is unknown - throw an error
        guard let response = networkResponse.response as? HTTPURLResponse else {
            
            throw Error.invalidURLResponseType
        }
        
        let data = networkResponse.data
        
        //parse the data
        guard
        let parameters = (try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any])?.map()
        else {
            
            throw Error.invalidParametersType
        }
        
        //if the error is one of the defined in the OAuth2 framework - throw it
        if let error = OAuth2Error(parameters: parameters.map()) {
            
            throw error
        }
        
        //make sure the response code is success 2xx
        guard (200..<300).contains(response.statusCode) else {
            
            throw Error.invalidHTTPStatusCode(response.statusCode)
        }
        
        self = try AccessTokenResponse(parameters: parameters)
    }
}

extension Dictionary where Key == String {

    public func map() -> [AccessTokenResponse.Parameter: Value] {
        
        reduce(into: [:]) { $0[.init(rawValue: $1.key)] = $1.value }
    }
}

extension Dictionary where Key == AccessTokenResponse.Parameter {
    
    public func map() -> [String: Value] {
        
        reduce(into: [:]) { $0[$1.key.rawValue] = $1.value }
    }
}

extension AccessTokenResponse {
    
    public enum Error: Swift.Error {
        
        ///Indicates that the `access_token` parameter is missing or invalid
        case invalidAccessToken
        
        ///Indicates that the `token_type` parameter is missing or invalid
        case invalidTokenType
        
        ///Indicates that the parsed parameters are not valid type. The expected type is [String: Any].
        case invalidParametersType
        
        ///Indicates that the URLResponse is not of HTTPURLResponse type
        case invalidURLResponseType
        
        ///Indicate that the HTTP Status code is not success 2xx.
        ///The error contains the received status code
        case invalidHTTPStatusCode(Int)
    }
}

