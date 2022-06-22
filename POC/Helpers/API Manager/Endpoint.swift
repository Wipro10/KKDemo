
import Foundation
import Combine

struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]
}

extension Endpoint {
    // We still have to keep 'url' as an optional, since we're
    // dealing with dynamic components that could be invalid.
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "eu-west-1.aws.data.mongodb-api.com"
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
}

protocol URLBuilder {
    var url: URL? { get }
}

enum POCEndpoints {
    case completeProfile
}

extension POCEndpoints: URLBuilder {
    var url: URL? {
        switch self {
        case .completeProfile:
            return Endpoint(path: "/app/chatreward-kytrn/endpoint/hello", queryItems: []).url
        }
    }
}
