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
    
     static func loadJsonDataFromFile(_ path: String, completion: (Data?) -> Void) {
        
        if let fileUrl = Bundle(for: MockResponseClient.self).url(forResource: path, withExtension: "json") {
               do {
                   let data = try Data(contentsOf: fileUrl, options: [])
                   completion(data as Data)
               } catch (let error) {
                   print(error.localizedDescription)
                   completion(nil)
               }
           }else{
               print("can decode")
           }
       }
    
    func makeRequest(route: Route, method: Methods, parameters: [String : Any]?, completion: @escaping (Result<Data, Error>) -> ())  {
        
        guard let request = createRequest(route: route, method: method, parameters: parameters) else{
            
            completion(.failure(AppError.invalidUrl))
            return
        }
        
        let anyURL = request.url
        
        
        //mock data to be returned by fake urlSession.downloadTask (MockURLProtocol) and returned to test fxn
        
       
        var anyData: Data?
        
        let filePath = "twitter_bookmarks_response"
        
        MockResponseClient.loadJsonDataFromFile(filePath, completion: { data in
                   if let json = data {
                       
                       anyData = json
                       
                   }else{
                       //failed to read from file
                       completion(.failure(AppError.unknownError))
                       return
                       
                   }
               })
           
        
        
        let anyResponse = HTTPURLResponse(url: anyURL!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        
        MockURLProtocol.stub(url: anyURL!, data: anyData, response: anyResponse, error: nil)
        
        urlSession.dataTask(with: request) {  data, response, error in
            var result: Result<Data,Error>?
            if let data = data {
                result = .success(data)
                
                completion(result!)
                
            }else if let error = error {
                result = .failure(error)
                completion(result!)
            }
            
        }.resume()
        
    }
    
    func handleResponse<T: Decodable>(result: Result<Data, Error>?, completion: (Result<T, Error>) -> ())  {
        
        
        guard let result = result else {
            completion(.failure(AppError.unknownError))
            return
        }
        
        switch result{
            
        case .success(let data):
            let decoder = JSONDecoder()
            
            //ApiResponse<T>.self is dynamic model based on request
          /*  guard let response = try? decoder.decode(ApiResponse<T>.self, from: data)else{
                completion(.failure(AppError.errorDecoding))
                return
                
            }*/
            
            let response: ApiResponse<T>
            
            do {
                  
                let decoder = JSONDecoder()
                 response = try decoder.decode(ApiResponse<T>.self, from: data)
                
               } catch let error {
                   print("Error", error)
                   return
               }
            
            
           /* if let error = response.error{
                completion(.failure(AppError.serverError(error)))
                return
            }*/
            
            if let decodedData = response.data{
                completion(.success(decodedData))
            }else{
                
                //probably no data from respinse
                completion(.failure(AppError.unknownError))
            }
            
        case .failure(let error):
            completion(.failure(error))
            return
        }
        
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
