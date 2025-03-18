import XCTest
@testable import LiveFlight

class FlightModelTests: XCTestCase {
    
    func testStateInitialization() {
        // Arrange
        let state = State(
            icao24: "ABC123",
            callSign: "ABC123",
            originCountry: "USA",
            timePosition: 123456789,
            lastContact: 987654321,
            longitude: -122.4194,
            latitude: 37.7749,
            baroAltitude: 500.0,
            onGround: false,
            velocity: 250.0,
            trueTrack: 180.0,
            verticalRate: 0.5,
            sensors: [1, 2],
            geoAltitude: 1000.0,
            squawk: "1234",
            spi: true,
            positionSource: 1
        )
        
        // Assert
        XCTAssertEqual(state.icao24, "ABC123", "ICAO24 doğru olmalı")
        XCTAssertEqual(state.callSign, "ABC123", "CallSign doğru olmalı")
        XCTAssertEqual(state.originCountry, "USA", "OriginCountry doğru olmalı")
        XCTAssertEqual(state.latitude, 37.7749, "Latitude doğru olmalı")
        XCTAssertEqual(state.longitude, -122.4194, "Longitude doğru olmalı")
        XCTAssertEqual(state.baroAltitude, 500.0, "BaroAltitude doğru olmalı")
        XCTAssertEqual(state.onGround, false, "OnGround doğru olmalı")
        XCTAssertEqual(state.velocity, 250.0, "Velocity doğru olmalı")
        XCTAssertEqual(state.trueTrack, 180.0, "TrueTrack doğru olmalı")
        XCTAssertEqual(state.verticalRate, 0.5, "VerticalRate doğru olmalı")
        XCTAssertEqual(state.sensors, [1, 2], "Sensors doğru olmalı")
        XCTAssertEqual(state.geoAltitude, 1000.0, "GeoAltitude doğru olmalı")
        XCTAssertEqual(state.squawk, "1234", "Squawk doğru olmalı")
        XCTAssertEqual(state.spi, true, "SPI doğru olmalı")
        XCTAssertEqual(state.positionSource, 1, "PositionSource doğru olmalı")
    }
    
    func testStateDecode() throws {
        // Arrange: JSON verisi (örnek)
        let jsonData = """
        {
            "icao24": "ABC123",
            "callSign": "ABC123",
            "originCountry": "USA",
            "timePosition": 123456789,
            "lastContact": 987654321,
            "longitude": -122.4194,
            "latitude": 37.7749,
            "baroAltitude": 500.0,
            "onGround": false,
            "velocity": 250.0,
            "trueTrack": 180.0,
            "verticalRate": 0.5,
            "sensors": [1, 2],
            "geoAltitude": 1000.0,
            "squawk": "1234",
            "spi": true,
            "positionSource": 1
        }
        """.data(using: .utf8)!
        
        // Act: JSON verisini decode et
        let decoder = JSONDecoder()
        let decodedState = try decoder.decode(State.self, from: jsonData)
        
        // Assert: Decode edilen verinin doğruluğunu kontrol et
        XCTAssertEqual(decodedState.icao24, "ABC123", "ICAO24 doğru olmalı")
        XCTAssertEqual(decodedState.callSign, "ABC123", "CallSign doğru olmalı")
        XCTAssertEqual(decodedState.originCountry, "USA", "OriginCountry doğru olmalı")
        XCTAssertEqual(decodedState.latitude, 37.7749, "Latitude doğru olmalı")
        XCTAssertEqual(decodedState.longitude, -122.4194, "Longitude doğru olmalı")
        XCTAssertEqual(decodedState.baroAltitude, 500.0, "BaroAltitude doğru olmalı")
        XCTAssertEqual(decodedState.onGround, false, "OnGround doğru olmalı")
        XCTAssertEqual(decodedState.velocity, 250.0, "Velocity doğru olmalı")
        XCTAssertEqual(decodedState.trueTrack, 180.0, "TrueTrack doğru olmalı")
        XCTAssertEqual(decodedState.verticalRate, 0.5, "VerticalRate doğru olmalı")
        XCTAssertEqual(decodedState.sensors, [1, 2], "Sensors doğru olmalı")
        XCTAssertEqual(decodedState.geoAltitude, 1000.0, "GeoAltitude doğru olmalı")
        XCTAssertEqual(decodedState.squawk, "1234", "Squawk doğru olmalı")
        XCTAssertEqual(decodedState.spi, true, "SPI doğru olmalı")
        XCTAssertEqual(decodedState.positionSource, 1, "PositionSource doğru olmalı")
    }
    
    func testFlightModelDecode() throws {
        // Arrange: JSON verisi (örnek)
        let jsonData = """
        {
            "time": 1609459200,
            "states": [
                {
                    "icao24": "ABC123",
                    "callSign": "ABC123",
                    "originCountry": "USA",
                    "timePosition": 123456789,
                    "lastContact": 987654321,
                    "longitude": -122.4194,
                    "latitude": 37.7749,
                    "baroAltitude": 500.0,
                    "onGround": false,
                    "velocity": 250.0,
                    "trueTrack": 180.0,
                    "verticalRate": 0.5,
                    "sensors": [1, 2],
                    "geoAltitude": 1000.0,
                    "squawk": "1234",
                    "spi": true,
                    "positionSource": 1
                }
            ]
        }
        """.data(using: .utf8)!
        
        // Act: JSON verisini decode et
        let decoder = JSONDecoder()
        let decodedFlightModel = try decoder.decode(FlightModel.self, from: jsonData)
        
        // Assert: Decode edilen FlightModel doğruluğunu kontrol et
        XCTAssertEqual(decodedFlightModel.time, 1609459200, "Time doğru olmalı")
        XCTAssertEqual(decodedFlightModel.states?.count, 1, "States listesi doğru sayıda uçuş içermeli")
        XCTAssertEqual(decodedFlightModel.states?.first?.icao24, "ABC123", "State'nin ICAO24 değeri doğru olmalı")
    }
}
