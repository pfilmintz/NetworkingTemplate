//
//  AppError.swift
//  NetworkingTemplate
//
//  Created by mac on 06/08/2022.
//

import Foundation

enum AppError: LocalizedError{
    case errorDecoding
    case unknownError
    case invalidUrl
    case serverError(String)
    
    var errorDescription: String?{
        switch self {
        case .errorDecoding:
            return "Response could not be decode"
        case .unknownError:
            return "uknown"
        case .invalidUrl:
            return "invalid url"
        case .serverError(let error):
            return error
        }
    }
}
