//
//  MessengerPresenter.swift
//  Messenger
//
//  Created by Nurzhigit Smailov on 4/10/19.
//  Copyright © 2019 Nurzhigit Smailov. All rights reserved.
//

import Foundation


class MessagePresenter{
    
    public weak var view: MessageView?
    var messages = [Message]()
    
    func getMessages(){
        view?.showLoading()
        let mark = Friend()
        mark.name = "Mark Zuckerberg"
        
        let message = Message()
        message.friend = mark
        message.text = "Good morning Steve Jobs Good morning Steve Jobs Good morning "
        message.date = NSDate()
        message.status = .outGoing
        let message2 = Message()
        message2.friend = mark
        message2.text = "Good morning Steve Jobs Good morning Steve Jobs Good morning Steve Jobs Good morning Steve Jobs Good morning Steve Jobs Good morning Steve Jobs Good morning Steve Jobs Good morning Steve Jobs Good morning Steve Jobs Good morning Steve Jobs Good morning Steve Jobs"
        message2.date = NSDate()
        message2.status = .inComing
        messages = [message, message2,message]
        
        let message3 = Message()
        message3.friend = mark
        message3.text = "Hello"
        message3.status = .inComing
        messages = [message3] + [message3] + [message2]  + messages
        view?.hideLoading()
        view?.showMessages(messages: messages)
    }
    
}


protocol MessageView: BaseView{
    func showMessages(messages: [Message])
}
