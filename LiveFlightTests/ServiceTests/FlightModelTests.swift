import XCTest
@testable import LiveFlight  // Test edilen modülü içe aktar

class FlightModelTests: XCTestCase {

    /// FlightModel'in manuel init ile doğru oluşturulduğunu test eder
    func testFlightModelInitialization() {
        let state = State(
            icao24: "abc123",
            callSign: "THY123",
            originCountry: "Turkey",
            timePosition: 1616161616,
            lastContact: 1616161617,
            longitude: 28.9784,
            latitude: 41.0082,
            baroAltitude: 10000.0,
            onGround: false,
            velocity: 250.0,
            trueTrack: 180.0,
            verticalRate: 500.0,
            sensors: [1, 2, 3],
            geoAltitude: 9800.0,
            squawk: "7500",
            spi: true,
            positionSource: 1
        )
        
        let flightModel = FlightModel(time: 1616161616, states: [state])
        
        XCTAssertEqual(flightModel.time, 1616161616)
        XCTAssertEqual(flightModel.states?.count, 1)
        XCTAssertEqual(flightModel.states?.first?.icao24, "abc123")
        XCTAssertEqual(flightModel.states?.first?.callSign, "THY123")
        XCTAssertEqual(flightModel.states?.first?.originCountry, "Turkey")
        XCTAssertEqual(flightModel.states?.first?.longitude, 28.9784)
        XCTAssertEqual(flightModel.states?.first?.latitude, 41.0082)
        XCTAssertEqual(flightModel.states?.first?.baroAltitude, 10000.0)
        XCTAssertEqual(flightModel.states?.first?.onGround, false)
    }

    /// JSON verisinin doğru şekilde `FlightModel` nesnesine dönüştüğünü test eder
    func testFlightModelDecoding() throws {
        let jsonData = """
        {
            "time": 1616161616,
            "states": [
                [
                    "abc123",
                    "THY123",
                    "Turkey",
                    1616161616,
                    1616161617,
                    28.9784,
                    41.0082,
                    10000.0,
                    false,
                    250.0,
                    180.0,
                    500.0,
                    [1, 2, 3],
                    9800.0,
                    "7500",
                    true,
                    1
                ]
            ]
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let flightModel = try decoder.decode(FlightModel.self, from: jsonData)

        XCTAssertEqual(flightModel.time, 1616161616)
        XCTAssertEqual(flightModel.states?.count, 1)
        XCTAssertEqual(flightModel.states?.first?.icao24, "abc123")
        XCTAssertEqual(flightModel.states?.first?.callSign, "THY123")
        XCTAssertEqual(flightModel.states?.first?.originCountry, "Turkey")
    }

    /// `FlightModel` nesnesinin JSON olarak doğru encode edildiğini test eder
    func testFlightModelEncoding() throws {
        let state = State(
            icao24: "abc123",
            callSign: "THY123",
            originCountry: "Turkey",
            timePosition: 1616161616,
            lastContact: 1616161617,
            longitude: 28.9784,
            latitude: 41.0082,
            baroAltitude: 10000.0,
            onGround: false,
            velocity: 250.0,
            trueTrack: 180.0,
            verticalRate: 500.0,
            sensors: [1, 2, 3],
            geoAltitude: 9800.0,
            squawk: "7500",
            spi: true,
            positionSource: 1
        )
        
        let flightModel = FlightModel(time: 1616161616, states: [state])
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted // JSON'u okunaklı hale getirmek için
        
        let jsonData = try encoder.encode(flightModel)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        
        XCTAssertTrue(jsonString.contains("\"time\" : 1616161616"))
        XCTAssertTrue(jsonString.contains("\"icao24\" : \"abc123\""))
        XCTAssertTrue(jsonString.contains("\"callSign\" : \"THY123\""))
        XCTAssertTrue(jsonString.contains("\"originCountry\" : \"Turkey\""))
    }
}
