import Foundation
import Alamofire
import UIKit.UIDevice

struct Client {

    public static var shared = Client()

    private let session: Alamofire.Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.headers["X-Device-ID"] = UIDevice.current.identifierForVendor!.uuidString
        return Alamofire.Session(configuration: configuration)
    }()

    private let baseURL = "https://warm-wave-23838.herokuapp.com/v1"

    func fetchElections(completion: @escaping ([Election]?) -> ()) {
        let url = "\(baseURL)/elections/"
        session.request(url, method: .get)
            .validate()
            .responseDecodable(of: Elections.self) { response in
                let elections = response.value?.all
                completion(elections)
            }
    }

    func fetchElectionWithID(_ electionID: String, completion: @escaping (Election?) -> ()) {
        let url = "\(baseURL)/elections/\(electionID)"
        session.request(url, method: .get)
            .validate()
            .responseDecodable(of: Election.self) { response in
                let election = response.value
                completion(election)
            }
    }

    func createElectionWithName(_ name: String, completion: @escaping (Election?) -> ()) {
        let url = "\(baseURL)/elections/"

        let parameters = [
            "title": "\(name)",
            "initiator_name": "\(UserNameStore.shared.name)"
        ]

        session.request(url, method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: Election.self) { response in
                let election = response.value
                completion(election)
        }
    }

    func joinElectionWithID(_ electionID: String, completion: @escaping (Election?) -> ()) {
        let url = "\(baseURL)/elections/\(electionID)/participants/"
        let parameters = [
            "name": UserNameStore.shared.name
        ]
        session.request(url, method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: Election.self) { response in
                let election = response.value
                completion(election)
        }
    }

    func leaveElectionWithID(_ electionID: String, completion: @escaping (Election?) -> ()) {
        let url = "\(baseURL)/elections/\(electionID)/participants/"
        session.request(url, method: .delete)
            .validate()
            .responseDecodable(of: Election.self) { response in
                let election = response.value
                completion(election)
        }
    }

    func changeElectionName(newName: String, electionID: String, completion: @escaping (Election?) -> ()) {
        let url = "\(baseURL)/elections/\(electionID)/"
        let parameters = [
            "title": "\(newName)",
        ]
        self.session.request(url, method: .put, parameters: parameters)
            .validate()
            .responseDecodable(of: Election.self) { response in
                let election = response.value
                completion(election)
        }
    }

    func searchForMoviesWithQuery(searchQuery: String, completion: @escaping ([Movie]?) -> ()) {
        let url = "\(baseURL)/movies/search/"
        let parameters = [
            "query": "\(searchQuery)",
        ]
        session.request(url, method: .get, parameters: parameters)
            .validate()
            .responseDecodable(of: Movies.self) { response in
                let movies = response.value?.all
                completion(movies)
            }
    }

    func createCandidateInElection(election: Election, forMovie movie: Movie, completion: @escaping (Election?) -> ()) {
        let url = "\(baseURL)/elections/\(election.id)/candidates/"
        let parameters = [
            "movie_id": "\(movie.id)",
        ]
        session.request(url, method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: Election.self) { response in
                let election = response.value
                completion(election)
            }
    }
}
