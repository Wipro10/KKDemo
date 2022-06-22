//
//  Endpoint.swift
//  Interlocutor
//
//  Created by Sathish M on 04/03/22.
//

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
        components.host = "stage-passport.peoplecert.org"
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
}

protocol URLBuilder {
    var url: URL? { get }
}

enum InterlocutorEndpoints {
    case login
    case session
    case testCentreAndVenues
    case sessionCandidate
    case country
    case closeSession
    case forgetPassword
    case setAbsent
    case candidateCloseout
    case lastMinCandidate
    case searchCandidate
    case eventLog
    case getMarkingCriteria
    case postMarkingCriteria
}

extension InterlocutorEndpoints: URLBuilder {
    var url: URL? {
        switch self {
        case .login:
            return Endpoint(path: "/InterlocutorAppService.asmx/GetTicket", queryItems: []).url
        case .session:
            return Endpoint(path: "/InterlocutorAppService.asmx/GetSessions", queryItems: []).url
        case .testCentreAndVenues:
            return Endpoint(path: "/InterlocutorAppService.asmx/GetMyTCsVenues", queryItems: []).url
        case .sessionCandidate:
            return Endpoint(path: "/InterlocutorAppService.asmx/GetSessionCandidates", queryItems: []).url
        case .country:
            return Endpoint(path: "/InterlocutorAppService.asmx/CountryPhones", queryItems: []).url
        case .closeSession:
            return Endpoint(path: "/InterlocutorAppService.asmx/CloseSession", queryItems: []).url
        case .forgetPassword:
            return Endpoint(path: "/InterlocutorAppService.asmx/ForgotPassword", queryItems: []).url
        case .setAbsent:
            return Endpoint(path: "/InterlocutorAppService.asmx/SetAbsent", queryItems: []).url
        case .candidateCloseout:
            return Endpoint(path: "/InterlocutorAppService.asmx/CandidateCloseout", queryItems: []).url
        case .lastMinCandidate:
            return Endpoint(path: "/InterlocutorAppService.asmx/AddLastMinuteCandidate", queryItems: []).url
        case .searchCandidate:
            return Endpoint(path: "/InterlocutorAppService.asmx/SearchCandidates", queryItems: []).url
        case .eventLog:
            return Endpoint(path: "/InterlocutorAppService.asmx/EventLog", queryItems: []).url
        case .getMarkingCriteria:
            return Endpoint(path: "/InterlocutorAppService.asmx/GetMarkingCriteria", queryItems: []).url
        case .postMarkingCriteria:
            return Endpoint(path: "/InterlocutorAppService.asmx/PostMarkingCriteria", queryItems: []).url
        }
    }
}
