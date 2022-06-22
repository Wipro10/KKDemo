//
//  APIService.swift
//  GenericNetworking
//
//  Created by vino on 01/02/22.
//

import Foundation
import Combine
import SwiftUI

enum HttpMethod: Equatable {
    
    case get
    case put(Data?)
    case post(Data?)
    case delete
    case head
    
    var name: String {
        switch self {
        case .get: return "GET"
        case .put: return "PUT"
        case .post: return "POST"
        case .delete: return "DELETE"
        case .head: return "HEAD"
        }
    }
    
}

struct Request<Response> {
    let url: URL
    var method: HttpMethod
    var headers: [String: String] = ["Content-Type": "application/json"]
}

extension Request {
    
    var urlRequest: URLRequest? {
        var request = URLRequest(url: url)
        switch method {
        case .post(let data), .put(let data):
            request.httpBody = data
        default:
            break
        }
        request.allHTTPHeaderFields = headers
        request.httpMethod = method.name
        return request
    }
    
    mutating func updateTicket(ticket: String) {
        do {
            if let body = urlRequest?.httpBody, var json = try JSONSerialization.jsonObject(with: body, options: []) as? [String : Any] {
                print("___________")
                json["ticket"] = ticket
                let jsonData = try? JSONSerialization.data(withJSONObject: json, options: [])
                let jsonString = String(data: jsonData!, encoding: .utf8)!
                print(jsonString)
                self.method = .post(jsonData)
            }
        } catch {
            print("erroMsg")
        }
    }
    
}


enum APIError: Error {
    case endpointError
    case networking(URLError)
    case decoding(Error)
}

extension URLSession {
    
    func publisher(for request: Request<Data>) -> AnyPublisher<Data, APIError> {
        guard let urlRequest = request.urlRequest else { return Fail(error: APIError.endpointError).eraseToAnyPublisher() }
        return dataTaskPublisher(for: urlRequest)
            .mapError(APIError.networking)
            .map(\.data)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func publisher(for request: Request<URLResponse>) -> AnyPublisher<URLResponse, APIError> {
        guard let urlRequest = request.urlRequest else { return Fail(error: APIError.endpointError).eraseToAnyPublisher() }
        return dataTaskPublisher(for: urlRequest)
            .mapError(APIError.networking)
            .map(\.response)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func publisher<Value: Decodable>(for request: Request<Value>,using decoder: JSONDecoder = .init()) -> AnyPublisher<Value, APIError> {
        guard let urlRequest = request.urlRequest else { return Fail(error: APIError.endpointError).eraseToAnyPublisher() }
        return dataTaskPublisher(for: urlRequest)
            .mapError(APIError.networking)
            .map(\.data)
            .map { data in
                print(request.url)
                print(request.headers)
                if let _body = request.urlRequest?.httpBody {
                    let body = String(decoding: _body, as: UTF8.self)
                    print(body)
                }
                
                print("response")
                print(String(decoding: data, as: UTF8.self))
                return data
            }
            .decode(type: Value.self, decoder: decoder)
            .mapError(APIError.decoding)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}


