import XCTest
@testable import LiveFlight
import Alamofire

class FlightServiceTests: XCTestCase {
    
    var flightService: FlightService!
    var mockNetworkManager: MockNetworkManager!
    
    // MARK: - Setup ve Teardown
    override func setUp() {
        super.setUp()
        
        mockNetworkManager = MockNetworkManager()
        NetworkManager.shared = mockNetworkManager // Global singleton'ı mocklayarak kullanıyoruz.
        
        flightService = FlightService.shared
    }
    
    override func tearDown() {
        flightService = nil
        mockNetworkManager = nil
        super.tearDown()
    }
    
    // MARK: - Başarılı API İsteği Testi
    func testFlightRequestSuccess() {
        let expectation = self.expectation(description: "API isteği başarılı olmalı ve veri döndürülmeli")
        
        // Başarılı bir model ile mock veri döndürüyoruz
        let mockFlightModel = FlightModel(
            states: [
                State(icao24: "ABC123", callSign: "FL123", originCountry: "US", timePosition: 123456789, lastContact: 123456789, longitude: -100.0, latitude: 40.0, baroAltitude: 10000.0, onGround: false, velocity: 300.0, trueTrack: 100.0, verticalRate: 5.0, sensors: [1], geoAltitude: 10000.0, squawk: "1234", spi: false, positionSource: 1)
            ]
        )
        
        // Mock network manager başarılı yanıt döndürsün.
        mockNetworkManager.mockResponse = .success(mockFlightModel)
        
        flightService.flightRequest { result in
            XCTAssertNotNil(result) // Sonuç null olmamalı
            XCTAssertEqual(result?.states?.count, 1) // States dizisinin 1 eleman içerdiği kontrol edilir.
            XCTAssertEqual(result?.states?.first?.icao24, "ABC123") // icao24 kontrolü yaptık.
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }

    // MARK: - Başarısız API İsteği Testi
    func testFlightRequestFailure() {
        let expectation = self.expectation(description: "API isteği başarısız olmalı ve hata döndürülmeli")
        
        // Hata döndürecek şekilde network manager'ı mockluyoruz
        mockNetworkManager.mockResponse = .failure(AFError.invalidURL(url: "invalid-url"))
        
        flightService.flightRequest { result in
            XCTAssertNil(result) // Başarısız olduğunda result null olmalı.
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}

// MARK: - MockNetworkManager
// Bu, NetworkManager'ın request fonksiyonunu mocklamak için kullanılan yardımcı sınıf.
class MockNetworkManager: NetworkManager {
    
    var mockResponse: Result<FlightModel, AFError>?
    
    override func request<T>(type: T.Type, url: String, method: HTTPMethod, parameters: [String : Any]?, completion: @escaping (Result<T, AFError>) -> Void) where T : Decodable {
        guard let response = mockResponse else {
            XCTFail("Mock response atanmamış!")
            return
        }
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) { // Simüle etmek için gecikme ekleyelim
            completion(response as! Result<T, AFError>)
        }
    }
}

