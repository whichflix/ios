import Foundation

struct UserNameStore {

    public var name: String {
        get {
            return UserDefaults.standard.string(forKey: "userName") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "userName")
        }
    }

    public func nameExists() -> Bool {
        guard name.count > 0 else { return false }
        return true
    }
}
