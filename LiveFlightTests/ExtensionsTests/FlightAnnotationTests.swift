import XCTest
import MapKit
@testable import LiveFlight

class FlightAnnotationTests: XCTestCase {
    
    func testFlightAnnotationInitialization_WithValidData_ShouldSetPropertiesCorrectly() {
        // Arrange: Sahte uçuş verisi oluşturuyoruz
        let flight = State(icao24: "ABC123",
                           callSign: "THY123",
                           originCountry: "Türkiye",
                           longitude: 30.0, latitude: 40.0,
                           trueTrack: 180.0)
        
        // Act: FlightAnnotation nesnesi oluşturuyoruz
        let annotation = FlightAnnotation(flight: flight)
        
        // Assert: Değerlerin doğru atandığını kontrol ediyoruz
        XCTAssertEqual(annotation.coordinate.latitude, 40.0, "Latitude yanlış atanmış")
        XCTAssertEqual(annotation.coordinate.longitude, 30.0, "Longitude yanlış atanmış")
        XCTAssertEqual(annotation.title, "THY123", "Callsign yanlış atanmış")
        XCTAssertEqual(annotation.subtitle, "Türkiye", "OriginCountry yanlış atanmış")
        XCTAssertEqual(annotation.trueTrack, 180.0, "TrueTrack yanlış atanmış")
        XCTAssertEqual(annotation.icao24, "ABC123", "ICAO24 yanlış atanmış")
    }
    
    func testFlightAnnotationInitialization_WithNilValues_ShouldUseDefaultValues() {
        // Arrange: Eksik uçuş verisi (nil değerler)
        let flight = State(icao24: nil,
                           callSign: nil,
                           originCountry: nil,
                           longitude: nil, latitude: nil,
                           trueTrack: nil)
        
        // Act
        let annotation = FlightAnnotation(flight: flight)
        
        // Assert: Varsayılan değerler atanmış mı?
        XCTAssertEqual(annotation.coordinate.latitude, 0.0, "Varsayılan latitude 0.0 olmalı")
        XCTAssertEqual(annotation.coordinate.longitude, 0.0, "Varsayılan longitude 0.0 olmalı")
        XCTAssertEqual(annotation.title, "Bilinmeyen Uçuş", "Varsayılan title atanmalı")
        XCTAssertEqual(annotation.subtitle, "Bilinmeyen Ülke", "Varsayılan subtitle atanmalı")
        XCTAssertNil(annotation.trueTrack, "Varsayılan TrueTrack nil olmalı")
        XCTAssertEqual(annotation.icao24, "UNKNOWN", "Varsayılan ICAO24 'UNKNOWN' olmalı")
    }
}
