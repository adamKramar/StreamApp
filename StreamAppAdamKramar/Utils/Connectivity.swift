//
//  Connectivity.swift
//  StreamAppAdamKramar
//
//  Created by Adam Kramar on 27/03/2020.
//  Copyright © 2020 Adam Kramar. All rights reserved.
//

import Foundation
import Alamofire

struct Connectivity {
    
    static let sharedInstance = NetworkReachabilityManager()!
    
    static var isConnectedToInternet: Bool {
        return self.sharedInstance.isReachable
    }
}
