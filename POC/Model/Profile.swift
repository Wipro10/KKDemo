
import Foundation

// MARK: - Profile
struct ProfileData: Codable {
    let success: Bool
    let data: Profile
}

// MARK: - DataClass
struct Profile: Codable {
    let title, message: String
}
