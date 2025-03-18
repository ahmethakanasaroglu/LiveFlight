import XCTest
@testable import LiveFlight

class FavoriteFlightCellTests: XCTestCase {

    var cell: FavoriteFlightCell!
    var flight: State!

    override func setUp() {
        super.setUp()
        // Cell örneğini oluşturuyoruz.
        cell = FavoriteFlightCell(style: .default, reuseIdentifier: "FavoriteFlightCell")
        
        // Test verisi (State objesi) oluşturuyoruz.
        flight = State(
            icao24: "ABC123",
            callSign: "Flight123",
            longitude: 15.0,
            latitude: 30.0
        )
    }

    override func tearDown() {
        // Test sonrası temizleme
        cell = nil
        flight = nil
        super.tearDown()
    }

    func testConfigureWithValidFlight() {
        // configure fonksiyonunu çağırıyoruz
        cell.configure(with: flight)
        
        // flightLabel'ın doğru metni gösterdiğini kontrol ediyoruz.
        XCTAssertEqual(cell.flightLabel.text, "Çağrı Kodu: Flight123")
        
        // icao24Label'ın doğru metni gösterdiğini kontrol ediyoruz.
        XCTAssertEqual(cell.icao24Label.text, "Adres: ABC123")
        
        // latitudeLabel'ın doğru metni gösterdiğini kontrol ediyoruz.
        XCTAssertEqual(cell.latitudeLabel.text, "Enlem: 30.0 m")
        
        // longitudeLabel'ın doğru metni gösterdiğini kontrol ediyoruz.
        XCTAssertEqual(cell.longitudeLabel.text, "Boylam: 15.0 m")
    }

    func testConfigureWithMissingFlightData() {
        // Eksik veri ile bir State objesi oluşturuyoruz
        let incompleteFlight = State(
            icao24: nil,
            callSign: "Flight123",
            longitude: nil,
            latitude: nil
        )
        
        // configure fonksiyonunu çağırıyoruz.
        cell.configure(with: incompleteFlight)
        
        // Bilgi eksikse, etiketlerin doğru default metni gösterdiğini kontrol ediyoruz.
        XCTAssertEqual(cell.icao24Label.text, "Adres: Bilinmiyor")
        XCTAssertEqual(cell.latitudeLabel.text, "Enlem Bilgisi Yok")
        XCTAssertEqual(cell.longitudeLabel.text, "Boylam Bilgisi Yok")
    }
}
