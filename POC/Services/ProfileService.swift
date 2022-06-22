

import Foundation
import Combine


class ProfileService: NetworkViewModel {
    var response = PassthroughSubject<ResponseState<ProfileData>, Never>()
    var request: Request<ProfileData>?
    var bag: Set<AnyCancellable> = Set<AnyCancellable>()
}

extension ProfileService {
    
    func completeProfile() {

        guard let url = POCEndpoints.completeProfile.url else {
            print("Error")
            return
        }

        self.request = Request(url: url, method: .get)
        
        self.fetch()

    }
    
}


