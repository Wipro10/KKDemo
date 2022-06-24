
import Foundation
import Combine


class HomeViewModel: ObservableObject {
    

    @Published var isLoading: Bool = false
    @Published var title: String = "COMPLETE YOUR PROFILE"
    @Published var message: String = "Take a few steps to show the kommunity who you really are"
    @Published var isShowAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var isProfileCompleted: Bool = false
    
    var bag: Set<AnyCancellable> = Set<AnyCancellable>()

    var profileService = ProfileService()
    
    init() {
        profileService.response
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { value in
            switch value {
            case .loading:
                self.isLoading = true
            case .success(let value):
                self.isLoading = false
                self.isProfileCompleted = true
                self.title = value.data.title
                self.message = value.data.message
            case .failure(let value):
                self.isLoading = false
                self.alertMessage = value
                self.isShowAlert = true
            }
        }).store(in: &bag)
    }
    
    func completeProfile() {
        profileService.completeProfile()
    }
}
