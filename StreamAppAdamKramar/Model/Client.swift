//
//  Client.swift
//  StreamAppAdamKramar
//
//  Created by Adam Kramar on 14/07/2020.
//  Copyright © 2020 Adam Kramar. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

struct Client {
    
    //perform requst with response type JSON
    func performRequestWithJSONResponse(with url: String,  completion: @escaping(Error?, Data?)->()) {
        AF.request(url).responseJSON { (response) in
            if let error = response.error {
                completion(error, nil)
            }
            if let data = response.data {
                completion(nil, data)
            }
        }
    }
    
    //perform requst with response type image
    func performRequestWithImageResponse (with url: String, completion: @escaping(Error?, Data?)->()) {
        AF.request(url).responseImage { response in
            if case .success(let image) = response.result {
                if let imageData = image.pngData() {
                    completion(nil, imageData)
                }
            } else if let error = response.error {
                completion(error, nil)
            }
        }
    }
    
}
