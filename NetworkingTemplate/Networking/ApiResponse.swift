//
//  ApiResponse.swift
//  NetworkingTemplate
//
//  Created by mac on 06/08/2022.
//

import Foundation

    //response from backend
struct ApiResponse<T: Decodable>: Decodable {
    let status: Int
    let message: String?
    
    //generic type T as placeholder to model
    let data: T?
    let error: String?
    
    
}
