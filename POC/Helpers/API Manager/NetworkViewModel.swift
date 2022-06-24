

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
            self.response.send(.failure(NSLocalizedString(Constants.noInternet, comment: "")))
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
                            self?.response.send(.failure("Decoding Error"))
                        case .networking(let err):
                            self?.response.send(.failure(err.localizedDescription))
                        case .endpointError:
                            self?.response.send(.failure("invalidUrl"))
                        }
                    case .finished:
                        break
                    }
                }, receiveValue: { [weak self] decodable in
                    self?.response.send(.success(decodable))
                })
                .store(in: &bag)
        } else {
            self.response.send(.failure("emptyRequest"))
        }
    }
    
}
