import Foundation

final class FlightService {
    
    static let shared = FlightService()
    
    func flightRequest(completion: @escaping (FlightModel?) -> ()) {
        NetworkManager.shared.request(type: FlightModel.self, url: "http://localhost:3000/LiveFlight/api") { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let data):
                completion(data)
            case .failure(let error):
                debugPrint(error.localizedDescription)
                completion(nil)
            }
        }
    }
    
}
// https://opensky-network.org/api/states/all
