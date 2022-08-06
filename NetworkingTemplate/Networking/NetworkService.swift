//
//  NetworkService.swift
//  NetworkingTemplate
//
//  Created by mac on 06/08/2022.
//

import Foundation


struct NetworkService{
    
    static let shared = NetworkService()
    
    private init(){}
    
    
    
    func myFirstRequest(completion: @escaping(Result<[itemModel],Error>) -> ()){
        request(route: .temp, method: .get, parameters: nil, completion: completion)
    }
 
    private func request<T: Decodable>(route: Route,
                                       method: Methods,
                                       parameters: [String:Any]? = nil,
                                       
                                       completion: @escaping(Result<T,Error>) -> ()){
        
        guard let request = createRequest(route: route, method: method, parameters: parameters) else{
            
            completion(.failure(AppError.invalidUrl))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data,response,error in
            var result: Result<Data,Error>?
            if let data = data {
                result = .success(data)
                
                let responseString = String(data: data, encoding: .utf8) ?? "Could not stringify data"
                print("The resonse is:\n\(responseString)")
            }else if let error = error {
                result = .failure(error)
                print("The error is \(error.localizedDescription)")
            }
            
            DispatchQueue.main.async {
                self.handleResponse(result: result, completion: completion)
            }
            
        }.resume()
        
    }
    
    /// THis function decodes data from APi
    /// - Parameters:
    ///   - result: tells me whether there is an error or there is data to be decoded from the response
    ///   - completion: me trying to return decoded data or error if dedcoding fails
    private func handleResponse<T: Decodable>(result: Result<Data,Error>?,
                                completion: (Result<T,Error>) -> ()){
        
        guard let result = result else {
            completion(.failure(AppError.unknownError))
            return
        }
        
        switch result{
            
        case .success(let data):
            let decoder = JSONDecoder()
            
            //ApiResponse<T>.self is dynamic model based on request
            guard let response = try? decoder.decode(ApiResponse<T>.self, from: data) else{
                completion(.failure(AppError.errorDecoding))
                return
                
            }
            
            if let error = response.error{
                completion(.failure(AppError.serverError(error)))
                return
            }
            
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
    
    /// This function helps us generate a url request
    /// - Parameters:
    ///   - route: path to the resource in the backend
    ///   - method: type of request to be made
    ///   - parameters: extra data to be passed to the backend
    /// - Returns: returns URlRequest
    private func createRequest(route: Route,
                               method: Methods,
                               parameters:[String: Any]? = nil) -> URLRequest?{
        
        let urlString = Route.baseURl + route.description
        
        guard let url = URL(string: urlString) else {return nil}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        urlRequest.httpMethod = method.rawValue
        
        if let parameters = parameters {
            switch method {
            case .get:
                //addding extra parameters to URL string
                var urlComponent = URLComponents(string: urlString)
                
                //addding params as url query items helps add the ? and & to url automatically
             //   for this url https://google.com/books?type=cartoon&page=1
                //urlCOmponent constructs ?type=cartoon&page=1
                
                urlComponent?.queryItems = parameters.map {
                    //for every key and value in param, convert to urlquery item
                    
                    /*
                     for (key, value) in parameters {
                         queryItems.append(URLQueryItem(name: key, value: value ))
                     }
                     */
                    
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
