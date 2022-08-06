//
//  NetworkServiceProtocol.swift
//  NetworkingTemplate
//
//  Created by mac on 06/08/2022.
//

import Foundation


//all functions in Network Service to be tested
protocol NetworkServiceProtocol{
    
     func request<T: Decodable>(route: Route,
                                       method: Methods,
                                       parameters: [String:Any]?,
                                       
                                       completion: @escaping(Result<T,Error>) -> ())
    
    func handleResponse<T: Decodable>(result: Result<Data,Error>?,
                                completion: (Result<T,Error>) -> ())
    
    func createRequest(route: Route,
                               method: Methods,
                               parameters:[String: Any]?) -> URLRequest?
    
    
}
