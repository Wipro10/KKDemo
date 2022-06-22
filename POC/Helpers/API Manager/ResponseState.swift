//
//  ResponseState.swift
//  GenericNetworking
//
//  Created by vino on 01/02/22.
//

import Foundation
import SwiftUI

enum ResponseState<T> {
    case loading
    case success(T)
    case failure(String)
}

extension ResponseState {

    var loading: Bool {

        if case .loading = self {
            return true
        }

        return false
    }

    var failure: String? {
        switch self {
        case .failure(let error):
            return error
        default:
            return nil
        }
    }

    var value: T? {
        switch self {
        case .success(let value):
            return value
        default:
            return nil
        }
    }
    
}


extension ResponseState {

    func isLoading<Content: View>(@ViewBuilder content: @escaping () -> Content) -> Content? {

        if loading {
            return content()
        }

        return nil
    }

    func hasResource<Content: View>(@ViewBuilder content: @escaping (T) -> Content) -> Content? {
        if let value = value {
            return content(value)
        }

        return nil
    }

    func hasError<Content: View>(@ViewBuilder content: @escaping (String) -> Content) -> Content? {

        if let error = failure {
            return content(error)
        }

        return nil
    }
    
}
