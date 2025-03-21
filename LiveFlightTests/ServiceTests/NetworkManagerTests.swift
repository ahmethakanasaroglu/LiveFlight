import XCTest
import Alamofire
@testable import LiveFlight

struct Model: Decodable, Equatable {
    let icao24: String
    let callSign: String
    let originCountry: String
    let timePosition: Int
    let lastContact: Int
    let longitude: Double
    let latitude: Double
    let baroAltitude: Float
    let onGround: Bool
    let velocity: Float
    let trueTrack: Float
    let verticalRate: Float
    let sensors: [Int]
    let geoAltitude: Float
    let squawk: String
    let spi: Bool
    let positionSource: Int
}

final class NetworkManagerTests: XCTestCase {
    
    var networkManager: NetworkManager!
    
    override func setUp() {
        super.setUp()
        networkManager = NetworkManager.shared
    }
    
    override func tearDown() {
        networkManager = nil
        super.tearDown()
    }
    
    // MARK: - Request metodunun çağrılabilir ve çalışabilir olduğu test ediliyor
    func testRequestMethodExists() {
        let expectation = self.expectation(description: "Request metodu mevcut ve çağrılabilir")
        
        networkManager.request(type: Model.self, url: "https://opensky-network.org/api/states/all") { result in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    // MARK: - Request metodunun başarısız bir isteği doğru şekilde işleyip işlemediğini test ediyoruz.
    func testRequestHandlesFailure() {
        let expectation = self.expectation(description: "Request failure doğru şekilde işliyor")
        
        networkManager.request(type: Model.self, url: "invalid-url") { result in
            switch result {
            case .success:
                XCTFail("Failure beklendi ama success oldu") // istek basarılı olursa test basarısız olcak
            case .failure(let error):
                XCTAssertNotNil(error, "Error nil olmamalı")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}


