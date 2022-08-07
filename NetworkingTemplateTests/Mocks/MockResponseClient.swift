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
        
        guard let request = createRequest(route: route, method: method, parameters: parameters) else{
            
            completion(.failure(AppError.invalidUrl))
            return
        }
        
        let anyURL = request.url
        
        let bundle = Bundle(for: type(of:self))
        let filePath = bundle.path(
                     forResource: "play", ofType: "png")
        
        //mock data to be returned by fake urlSession.downloadTask (MockURLProtocol) and returned to test fxn
        let anyData = try?
                     Data(contentsOf:
                     URL(fileURLWithPath: filePath!))
        
        
        
        //let anyData = Data("any data".utf8)
        let anyResponse = HTTPURLResponse(url: anyURL!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        
        MockURLProtocol.stub(url: anyURL!, data: <#T##Data?#>, response: anyResponse, error: nil)
        
        urlSession.dataTask(with: request) {  data, response, error in
            var result: Result<Data,Error>?
            if let data = data {
                result = .success(data)
                
                let responseString = String(data: data, encoding: .utf8) ?? "Could not stringify data"
                print("The resonse is:\n\(responseString)")
            }else if let error = error {
                result = .failure(error)
                print("The error is \(error.localizedDescription)")
            }
            
        }.resume()
        
    }
    
    func handleResponse<T>(result: Result<Data, Error>?, completion: (Result<T, Error>) -> ()) where T : Decodable {
        
    }
    
   
    
    func createRequest(route: Route, method: Methods, parameters: [String : Any]?) -> URLRequest? {
        
        let urlString = Route.baseUrl + route.description
        
        guard let url = URL(string: urlString) else {return nil}
        
        var urlRequest = URLRequest(url: url)
        let BearerToken =  "Zjl4S2hYUHBPUk4"
        
        urlRequest.addValue("Bearer \(BearerToken)", forHTTPHeaderField: "Authorization")
        
        urlRequest.httpMethod = method.rawValue
        
        if let parameters = parameters {
            switch method {
            case .get:
                
                var urlComponent = URLComponents(string: urlString)
                
                
                urlComponent?.queryItems = parameters.map {
                    
                    URLQueryItem(name: $0, value: "\($1)")
                    
                }
                
                urlRequest.url = urlComponent?.url
                
            case .post,.delete:
                //converting dic into json
                let bodyData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
                urlRequest.httpBody = bodyData
          
            }
        }
        
        return urlRequest
    }
    
   
    
 
    
    
}
