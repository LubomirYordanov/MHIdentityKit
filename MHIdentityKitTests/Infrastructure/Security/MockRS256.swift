//
//  MockRS256.swift
//  MHIdentityKit
//
//  Created by Milen Halachev on 23.08.19.
//  Copyright © 2019 Milen Halachev. All rights reserved.
//

import Foundation

struct MockRS256 {
    
    let input = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6Ik5EZ3dNalExUmpORk4wTkVSRE5FT1RKRk1qSkNRa1U0UmpNNU16VkdSVFJHTURRM01qazBOQSJ9.eyJodHRwczovL3N0cm93ci5jb20vaW50ZXJuYWxfaWQiOiJ1cm46c3Ryb3dyLWRldmVsb3BtZW50OnVzZXI6ZjEzODYwYTYtZjlmNi00N2MzLTlmODUtODE5NDMyN2ZjYTZlIiwiaXNzIjoiaHR0cHM6Ly9zdHJvd3ItZGV2ZWxvcG1lbnQuZXUuYXV0aDAuY29tLyIsInN1YiI6ImF1dGgwfDVjNTQ2MjVkNzVlYjAyMDk2ZmRjMzczNyIsImF1ZCI6Imh0dHBzOi8vYXBpLWludC5zdHJvd3IuY29tIiwiaWF0IjoxNTY2MzcyMDkyLCJleHAiOjE1NjY0NTg0OTIsImF6cCI6ImtJUU02bTV2dFA4bTFzZnBYN1pNN1phdktnMkp5NDVjIiwiZ3R5IjoicGFzc3dvcmQifQ".data(using: .ascii)!
    
    let signature = Data(base64UrlEncoded: "TpDnNIjGoolN-oIobinYgK2ipiYE69LTovCvSMmx501FSUN37XR-dYNDOWyH1O6xAGvID66xHBs5e7PwM01RC2u1AJOkrSqEjAcWvqu89gfh57rwAePnkpryL73T-RqUB6z6NaTvm-vFv0uawvd-LA0jcWJiKv6j8K446AaWuBZylsUtlAR3ousERmp4EooAAYGnSYEJtCdJ_-S1Isk1z_CmoHaLBgpVJUBohaZHsAtetTQ8YxC4Blg3ko1G0-xQ4qKyWoI9Conn_IC3KNLHsTmBSk1Yq3fIX9O-PVqYxsL2Asekdj-qCZl7mdRI3EE4MDhyhuoNrlng8vFWzNouvw")!
    
    //x5c
    let certificate = "MIIDGTCCAgGgAwIBAgIJQ9AWv8SzyokyMA0GCSqGSIb3DQEBCwUAMCoxKDAmBgNVBAMTH3N0cm93ci1kZXZlbG9wbWVudC5ldS5hdXRoMC5jb20wHhcNMTkwMjAxMTUwNDU4WhcNMzIxMDEwMTUwNDU4WjAqMSgwJgYDVQQDEx9zdHJvd3ItZGV2ZWxvcG1lbnQuZXUuYXV0aDAuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0PMn0dVPGCTZvzYl2uuB+UrtA3Cat0p5nsJVEV9YDjp0XH7f75X1l9Mtjynnbq0dhZH3DywwTFHGqcnY9EoMFFY+oo9LjtsO9Kgb+mmLG7QfqA0i2houjc1pK+aFypbiJA56yrPp9K24s2YBGOBNEX3KG4XH3pu8EeRyfpD8OyXP1zmRE21AhL26sHV7GmXNgWE1vtxarxjai8kisxKje7B81COqQcfExxAmXCG3unETz8szEceSRfNHB35mc5VKq8mgIjmZDGTsrcReRclwpJVUinKu1bEjyv4C3ekebTZCQgXqAUbCSMWffNCbj1xht/IimZGyGSSHEW/muy2L+QIDAQABo0IwQDAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBShlanHoOK8MgtWwNxdWo3ee7UVdjAOBgNVHQ8BAf8EBAMCAoQwDQYJKoZIhvcNAQELBQADggEBAKd4FG4Dxt3rc+YbAuu1QK1vNISUO0sk2pp+e9MtKiL5V+SgNwMZz+izA4XnR40y7TwGOS0ldclP+fcVM4NkIMabIGzC+0kWc9DRZHiBazlN6nBx2Ylh9lk85p7w4Sj0Eldv+sSYM0mTJWIdW1/kudLXIROTOU6K6ssFfTdVcwrmYdWvPnmSg5VHlCh81ayApbVJrYUBJ1Tve0iXmIgSkITnnvmHXvR2kwdyJ9tm9HtAqQCWx8pY+UuQuuZDAeB7qXaXK3EwEnBBXKMnNYYt5MEOHnnnEcydDPWFkJqkzC/BxKAALG6QRDF521CCzMwWRzNo9cJM4pKO8RodwfBsdNw="
}
