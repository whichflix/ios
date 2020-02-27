import Foundation
import Alamofire
import UIKit.UIDevice

class Observer : ObservableObject {
    @Published var elections = [Election]()

    private lazy var session: Alamofire.Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.headers["X-Device-ID"] = UIDevice.current.identifierForVendor!.uuidString
        return Alamofire.Session(configuration: configuration)
    }()

    init() {
        getElections()
    }

    func getElections()
    {
        let url = "https://warm-wave-23838.herokuapp.com/v1/elections/"
        session.request(url).validate()
          .responseDecodable(of: Elections.self) { response in
            guard let elections = response.value else { return }
            self.elections = elections.all
        }
    }
}

