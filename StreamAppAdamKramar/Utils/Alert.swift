//
//  Alert.swift
//  StreamAppAdamKramar
//
//  Created by Adam Kramar on 27/03/2020.
//  Copyright © 2020 Adam Kramar. All rights reserved.
//

import UIKit
 
class Alert {
 
    static func show(title: String, message: String, cancel: String, ctrl: UIViewController) {
        let controller: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: cancel, style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        ctrl.present(controller, animated: true, completion: nil)
    }
}
