//
//  Route.swift
//  NetworkingTemplate
//
//  Created by mac on 06/08/2022.
//

import Foundation

public enum Route{
    
    static let baseUrl = "https://api.twitter.com"
    
    case bookmarks
    
    var description: String{
        switch self {
        case .bookmarks:
            return "/2/users/\(834009971746553856)/bookmarks"
        }
        
    }
}
