//
//  Download.swift
//  Messenger
//
//  Created by Nurzhigit Smailov on 5/3/19.
//  Copyright © 2019 Nurzhigit Smailov. All rights reserved.
//

import Foundation
import UIKit
protocol DownloaderDelegate: class {
    func progress(_ progress: Float)
    func didFinish(image: UIImage)
    func didFinish(path: String)
}

class Downloader: NSObject {
    weak var delegate: DownloaderDelegate?
    var downloadTask = URLSessionDownloadTask()
    func download() {
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        let imageUrlString = ["https://images.unsplash.com/photo-1532960401447-7dd05bef20b0?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=758&q=80", "https://images.unsplash.com/photo-1449951862793-5ca2f854dcaa?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1951&q=80", "https://images.unsplash.com/photo-1464536273402-2c9168fe63aa?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1950&q=80", "https://images.unsplash.com/photo-1449951862793-5ca2f854dcaa?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1951&q=80", "https://images.unsplash.com/photo-1436377734980-0ee004df570b?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2010&q=80"]
        let videoUrl = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4"
        let randomNumber = Int.random(in: 0 ... imageUrlString.count-1)
        let url = URL(string: imageUrlString[randomNumber])!
        let url2 = URL(string: videoUrl)!
        downloadTask = session.downloadTask(with: url2)
        downloadTask.resume()
    }
    func stopDownloading(){
        downloadTask.cancel()
    }
}

extension Downloader: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let imageData = try? Data(contentsOf: location)
        if let image = UIImage(data: imageData!){
            delegate?.didFinish(image: image)
        } else{
            delegate?.didFinish(path: location.path)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        delegate?.progress(Float(totalBytesWritten * 100 / totalBytesExpectedToWrite))
    }
    
}
