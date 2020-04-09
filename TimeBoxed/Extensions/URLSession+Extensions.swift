//
//  URLSession+Extensions.swift
//  NextPomodoro
//
//  Created by Paul Traylor on 2020/01/16.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import os
import Foundation

typealias AuthedRequestResponse = ((Result<Data, Error>) -> Void)

extension URLSession {
    enum Methods: String {
        case GET
        case POST
        case DELETE
        case PUT
        case PATCH
    }

    func authedRequest(path: String, method: URLSession.Methods, body: Data? = nil, queryItems: [URLQueryItem]? = [], completionHandler: @escaping AuthedRequestResponse) {
        guard let username = Settings.defaults.string(forKey: .currentUser) else { return }
        guard let password = Settings.keychain.string(for: username) else { return }
        authedRequest(path: path, method: method, body: body, queryItems: queryItems, username: username, password: password, completionHandler: completionHandler)
    }

    func authedRequest(url: URLComponents, method: URLSession.Methods, body: Data? = nil, completionHandler: @escaping AuthedRequestResponse) {
        guard let username = Settings.defaults.string(forKey: .currentUser) else { return }
        guard let password = Settings.keychain.string(for: username) else { return }
        authedRequest(url: url, method: method, body: body, username: username, password: password, completionHandler: completionHandler)
    }

    private func authedRequest(path: String, method: URLSession.Methods, body: Data? = nil, queryItems: [URLQueryItem]? = [], username: String, password: String, completionHandler: @escaping AuthedRequestResponse) {
        guard let host = Settings.defaults.string(forKey: .currentUser) else { return }
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        components.queryItems = queryItems

        authedRequest(url: components, method: method, body: body, username: username, password: password, completionHandler: completionHandler)
    }

    func authedRequest(url: URLComponents, method: URLSession.Methods, body: Data? = nil, username: String, password: String, completionHandler: @escaping AuthedRequestResponse) {
        var request = URLRequest(url: url.url!)

        let loginString = "\(username):\(password)"
        guard let loginData = loginString.data(using: String.Encoding.utf8) else {
            return
        }
        let base64LoginString = loginData.base64EncodedString()
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        request.httpMethod = method.rawValue
        request.httpBody = body

        let task = dataTask(with: request, completionHandler: {data, response, error -> Void in
            if let httpResponse = response as? HTTPURLResponse {
                os_log("Request: %s %s %d", log: .networking, type: .debug, method.rawValue, httpResponse.url!.absoluteString, httpResponse.statusCode)
                completionHandler(.success(data!))
            } else {
                completionHandler(.failure(error!))
            }
        })
        task.resume()
    }
}
