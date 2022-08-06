//
//  MockURLProtocol.swift
//  NetworkingTemplateTests
//
//  Created by mac on 06/08/2022.
//

import Foundation

import XCTest

//Mocking URLSEssion network call
class MockURLProtocol: URLProtocol{
    
    private static var stubs = [URL: Stub]()
    
    private struct Stub {
             let data: Data?
             let response: URLResponse?
             let error: Error?
         }
         
         static func stub(url: URL, data: Data?, response: URLResponse?, error: Error?) {
             stubs[url] = Stub(data: data, response: response, error: error)
         }
    
    
    //to connect test to this protocol
    
    //We will use this model object to set the response, data, or error for requests.
    //static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        
        //called when urltask is instantiated in test
        
        
        guard let url = request.url, let stub = MockURLProtocol.stubs[url] else {
            return
            
        }
        
        if let data = stub.data {
                        client?.urlProtocol(self, didLoad: data)
                    }
                    
                    if let response = stub.response {
                        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                    }
                    
                    if let error = stub.error {
                        client?.urlProtocol(self, didFailWithError: error)
                    }
                    
        //returns data back to Urlsession task indicating receive of response
        client?.urlProtocolDidFinishLoading(self)
        
      
        
        
        }
    
    override func stopLoading() {
        
    }
}
