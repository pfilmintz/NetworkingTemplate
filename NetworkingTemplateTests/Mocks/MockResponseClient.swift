//
//  MockResponseClient.swift
//  NetworkingTemplateTests
//
//  Created by mac on 06/08/2022.
//

import Foundation
@testable import NetworkingTemplate

class MockResponseClient{
    
    let urlSession: URLSession
   
    init(urlSession: URLSession = .shared){
        
        self.urlSession = urlSession
        
    }
    
}



extension MockResponseClient: NetworkServiceProtocol{
    //mock requests here
    
    func request<T: Decodable>(route: Route, method: Methods, parameters: [String : Any]?, completion: @escaping (Result<T, Error>) -> ())  {
        <#code#>
    }
    
    func handleResponse<T>(result: Result<Data, Error>?, completion: (Result<T, Error>) -> ()) where T : Decodable {
        <#code#>
    }
    
   
    
    func createRequest(route: Route, method: Methods, parameters: [String : Any]?) -> URLRequest? {
        <#code#>
    }
    
   
    
 
    
    
}
