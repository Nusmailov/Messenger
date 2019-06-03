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
        let textString = "Good morning Steve Jobs Good morning Steve Jobs Good morning Steve Jobs Good morning Steve Jobs Good morning Steve Jobs Good morning Steve Jobs Good morning Steve Jobs Good morning Steve Jobs Good morning Steve Jobs Good morning Steve Jobs Good morning Steve Jobs"
        let message = Message(text: "Good morning Steve Jobs Good morning Steve Jobs Good morning", date: Date(), friend: mark, status: 0)
        let message2 = Message(text: textString, date: Date(), friend: mark, status: 0)
        
        messages = [message, message2,message]
        let message3 = Message(text: "Hello", date: Date(), friend: mark, status: 0 )
        messages = [message3] + [message3] + [message2]  + messages
        view?.hideLoading()
        view?.showMessages(messages: messages)
    }
    
}


protocol MessageView: BaseView{
    func showMessages(messages: [Message])
}
