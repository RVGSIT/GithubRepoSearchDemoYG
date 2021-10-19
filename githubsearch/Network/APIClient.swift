//
//  APIClient.swift
//  githubsearch
//
//  Created by Rachit Vyas on 10/16/21.
//  Copyright © 2021 Globalsys. All rights reserved.
//

import Foundation

typealias APIHandler = (Data?, URLResponse?, Error?) -> Swift.Void
typealias DownloadHandler = (URL) -> Swift.Void

/*
 Base class to make API calls.
 */

final class APIClient: NSObject, URLSessionDownloadDelegate {

    private static let shared = APIClient()

    private let operationQueue: OperationQueue

    private var downloadHandlers: [Int: DownloadHandler]?

    private lazy var configuration: URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.default
        configuration.allowsCellularAccess = true
        configuration.requestCachePolicy = .reloadIgnoringCacheData
        return configuration
    }()

    private lazy var session: URLSession = {
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: self.operationQueue)
        session.sessionDescription = "session.data"
        return session
    }()

    private lazy var backgroundSession: URLSession = {
        let bgConfiguration = URLSessionConfiguration.background(withIdentifier: "configuration.bg")
        configuration.allowsCellularAccess = true
        configuration.requestCachePolicy = .reloadIgnoringCacheData

        let backgroundSession = URLSession(configuration: bgConfiguration, delegate: self, delegateQueue: self.operationQueue)
        backgroundSession.sessionDescription = "session.bg"

        return backgroundSession
    }()

    private override init() {
        self.operationQueue = OperationQueue()
        self.operationQueue.maxConcurrentOperationCount = 10

        super.init()
    }

    class func dataTaskExecute(request: URLRequest, apiHandler: @escaping APIHandler) {
        let dataTask = APIClient.shared.session.dataTask(with: request, completionHandler: apiHandler)
        dataTask.resume()
    }

    class func downloadTaskExecute(request: URLRequest, downloadHandler: @escaping DownloadHandler) {
        let downloadTask = APIClient.shared.backgroundSession.downloadTask(with: request)
        APIClient.shared.downloadHandlers = [downloadTask.taskIdentifier: downloadHandler]
        downloadTask.resume()
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let handler = APIClient.shared.downloadHandlers?[downloadTask.taskIdentifier]
        handler?(location)
        APIClient.shared.downloadHandlers?.removeValue(forKey: downloadTask.taskIdentifier)
    }
}
