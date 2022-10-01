//
//  File.swift
//  
//
//  Created by Łukasz Rutkowski on 13/02/2022.
//

import Foundation

extension Twift {
    public func call<T: Decodable>(path: String,
                                   method: HTTPMethod = .GET,
                                   queryItems: [URLQueryItem] = [],
                                   body: Data? = nil
    ) async throws -> T {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.twitter.com"
        components.path = path
        components.queryItems = queryItems
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: ":", with: "%3A")

        let url = components.url!
        var request = URLRequest(url: url)

        if let body = body {
            request.httpBody = body
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        signURLRequest(method: method, body: body, request: &request)

        let (data, _) = try await URLSession.shared.data(for: request)

        return try decoder.decode(T.self, from: data)
    }

    public func callRaw(path: String,
                        method: HTTPMethod = .GET,
                        queryItems: [URLQueryItem] = [],
                        body: Data? = nil
    ) async throws -> String? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.twitter.com"
        components.path = path
        components.queryItems = queryItems

        let url = components.url!
        var request = URLRequest(url: url)

        if let body = body {
            request.httpBody = body
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        signURLRequest(method: method, body: body, request: &request)

        let (data, _) = try await URLSession.shared.data(for: request)
        return String(data: data, encoding: .utf8)
    }
}
