//
//  BaseView.swift
//  Messenger
//
//  Created by Nurzhigit Smailov on 3/27/19.
//  Copyright © 2019 Nurzhigit Smailov. All rights reserved.
//

import Foundation

protocol BaseView: class {
    func showLoading()
    func hideLoading()
    func showError(errorMessage: String)
}
