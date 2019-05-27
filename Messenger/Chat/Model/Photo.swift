//
//  Photo.swift
//  Messenger
//
//  Created by Nurzhigit Smailov on 5/2/19.
//  Copyright © 2019 Nurzhigit Smailov. All rights reserved.
//
import Foundation
import SwiftyJSON

class Photos: Decodable {
    var photos: Photooooo
    
    struct Photooooo: Decodable {
        var photo: [Photo]?
    }
}

class Photo: Decodable{
    var farm : Int
    var id : String
    var isfamily: Int
    var isfriend : Int
    var ispublic : Int
    var owner : String
    var secret : String
    var server : String
    var title : String
    
    init(json: [String: Any]){
        id = json["id"] as? String ?? ""
        owner = json["owner"] as? String ?? ""
        secret = json["secret"] as? String ?? ""
        server = json["server"] as? String ?? ""
        title = json["title"] as? String ?? ""
        ispublic = json["ispublic"] as? Int ?? -1
        isfriend = json["isfriend"] as? Int ?? -1
        isfamily = json["isfamily"] as? Int ?? -1
        farm = json["farm"] as? Int ?? -1
    }
    
    enum CodingKeys: String, CodingKey{
        case id = "id"
        case owner = "owner"
        case secret = "secret"
        case server = "server"
        case title = "title"
        case ispublic = "ispublic"
        case isfriend = "isfriend"
        case isfamily = "isfamily"
        case farm = "farm"
    }

    func getImageUrl() -> URL {
        let url = "http://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg"
        return URL.init(string: url)!
    }
    
}
