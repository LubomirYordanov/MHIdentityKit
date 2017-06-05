//
//  MHIdentityKitTests.swift
//  MHIdentityKitTests
//
//  Created by Milen Halachev on 4/11/17.
//  Copyright © 2017 Milen Halachev. All rights reserved.
//

import XCTest
@testable import MHIdentityKit

extension String: Error {}

class TestNetworkClient: NetworkClient {
    
    let handler: (URLRequest, (NetworkResponse) -> Void) -> Void
    
    init(handler: @escaping (URLRequest, (NetworkResponse) -> Void) -> Void) {
        
        self.handler = handler
    }
    
    func perform(request: URLRequest, handler: @escaping (NetworkResponse) -> Void) {
        
        self.handler(request, handler)
    }
}

class MHIdentityKitTests: XCTestCase {
    
    func testScope() {
        
        XCTAssertEqual(Scope(value: "read write").components, ["read", "write"])
        XCTAssertEqual(Scope(components: ["read", "write"]).value, "read write")
        
    }
}
