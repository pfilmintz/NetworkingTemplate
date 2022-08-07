//
//  itemModell.swift
//  NetworkingTemplate
//
//  Created by mac on 06/08/2022.
//

import Foundation


struct TwitterAPIResponse: Decodable{
   let data: [Tweet]
   let includes: Includes
}

struct Tweet: Decodable{
    let id:String
    let text: String
    let attachments: Attachments?
   //
}

struct Attachments: Decodable{
    
    let media_keys: [String]
    
}

struct Includes: Decodable{
    
    let media: [Media]
    
}

struct Media: Decodable{
    
    let media_key: String
    let type: String
    let url: String?
    let preview_image_url: String?
    
}

