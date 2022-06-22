//
//  NetworkViewModel.swift
//  GenericNetworking
//
//  Created by vino on 01/02/22.
//

import Foundation
import Combine
import Network
import Connectivity

protocol NetworkViewModel: ObservableObject {
    associatedtype NetworkResource: Decodable
    var response: PassthroughSubject<ResponseState<NetworkResource>, Never> { get set }
    var bag: Set<AnyCancellable> { get set }
    var request: Request<NetworkResource>? { get set }
}

extension NetworkViewModel {
    
    func fetch() {

        let connectivity: Connectivity = Connectivity()
        connectivity.isPollingEnabled = true
        connectivity.startNotifier()
        connectivity.framework = .network

        let connectivityChanged: (Connectivity) -> Void = { [weak self] connectivity in
             self?.updateConnectionStatus(connectivity.status)
             connectivity.stopNotifier()
        }
        
        connectivity.whenConnected = connectivityChanged
        connectivity.whenDisconnected = connectivityChanged

    }
    
    func updateConnectionStatus(_ status: Connectivity.Status) {
        
        switch status {
            
        case .connected, .connectedViaCellular, .connectedViaEthernet, .connectedViaWiFi:
            print("connected")
            self.fetchRequest()
        case .notConnected, .connectedViaWiFiWithoutInternet, .connectedViaCellularWithoutInternet, .connectedViaEthernetWithoutInternet:
            print("No connection.")
            self.response.send(.failure("No Internet Connection"))
        case .determining:
            break
        }
        
    }
    
    func fetchRequest() {
        if let _request = request {
            self.response.send(.loading)
            URLSession.shared.publisher(for: _request)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .failure(let error):
                        print(error)
                        switch error {
                        case .decoding(_):
                            self?.response.send(.failure(Constants.NetworkViewModel.Name.decodingError))
                        case .networking(let err):
                            self?.response.send(.failure(err.localizedDescription))
                        case .endpointError:
                            self?.response.send(.failure(Constants.NetworkViewModel.Name.invalidUrl))
                        }
                    case .finished:
                        break
                    }
                }, receiveValue: { [weak self] decodable in
                    if let status = (decodable as? BaseDataProtocol)?.status {
                        if status == 2001 {
                            self?.getToken()
                        } else if status == 2004 {
                            self?.response.send(.failure("Username or password is not valid."))
                        } else if let errorMessage = (decodable as? BaseDataProtocol)?.CheckError() {
                            self?.response.send(.failure(errorMessage))
                        } else {
                            self?.response.send(.success(decodable))
                        }
                    }
                    
                })
                .store(in: &bag)
        } else {
            self.response.send(.failure(Constants.NetworkViewModel.Name.emptyRequest))
        }
    }
    
    
    func getToken() {
        let ticketService = TicketService()
        if let _request = ticketService.getTicketRequest() {
            URLSession.shared.publisher(for: _request)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [weak self]  completion in
                    switch completion {
                    case .failure(let error):
                        print(error)
                        switch error {
                        case .decoding(_), .endpointError:
                            self?.response.send(.failure("Server Error"))
                        case .networking(let err):
                            self?.response.send(.failure(err.localizedDescription))
                        }
                    case .finished:
                        break
                    }
                }, receiveValue: { [weak self] decodable in
                    UserDefaults.ticket = decodable.ticket
                    if let ticket = UserDefaults.ticket {
                        self?.request?.updateTicket(ticket: ticket)
                        self?.fetch()
                    } else {
                        self?.response.send(.failure("Server Error"))
                    }
                }).store(in: &bag)
        }
    }
    
}
