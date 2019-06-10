//
//  PhotoService.swift
//  Messenger
//
//  Created by Nurzhigit Smailov on 5/2/19.
//  Copyright © 2019 Nurzhigit Smailov. All rights reserved.
//

import Foundation


class PhotoService: NSObject {
    
    static func getMainDate(success: @escaping ([Photo]) -> Void, failure: @escaping (Error) -> Void) {
        let jsonUrlString = "https://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=407902b4e99781ae7d33552db35a119c&per_page=1&page=1&format=json&nojsoncallback=1&auth_token=72157678069643627-d931a744cdf58a9c&api_sig=e27e267bbe776d958694c230092981fa"
        guard let url = URL(string: jsonUrlString) else { return }
        
        URLSession.shared.dataTask(with: url) {(data, response, err) in
            guard let data = data else{ return }
            do {
                let decoder = JSONDecoder()
                let photo = try decoder.decode(Photos.self,from: data)
                success(photo.photos.photo ?? [])
            } catch let error{
                failure(error)
            }
        }.resume()
    }
}

