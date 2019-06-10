//
//  MessageType.swift
//  Messenger
//
//  Created by Nurzhigit Smailov on 6/10/19.
//  Copyright © 2019 Nurzhigit Smailov. All rights reserved.
//

import Foundation
import UIKit

enum MessageType: Int {
    case inComing = 0
    case outGoing = 1
    
    var backgroundColor: UIColor {
        switch self {
            case .inComing:
                return UIColor(white: 0.9, alpha: 1)
            case .outGoing:
                return .blue
        }
    }
    
    var textColor: UIColor {
        switch self {
            case .inComing:
                return .black
            case .outGoing:
                return .white
        }
    }
    
}
