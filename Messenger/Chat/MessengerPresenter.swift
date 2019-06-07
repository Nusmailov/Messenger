//
//  MessengerPresenter.swift
//  Messenger
//
//  Created by Nurzhigit Smailov on 4/10/19.
//  Copyright © 2019 Nurzhigit Smailov. All rights reserved.
//

import Foundation


class MessagePresenter {
    
    public weak var view: MessageView?
    var messages = [Message]()
    
    func getMessages() {
        view?.showLoading()
        view?.hideLoading()
        view?.showMessages(messages: messages)
    }
}


protocol MessageView: BaseView {
    func showMessages(messages: [Message])
}
