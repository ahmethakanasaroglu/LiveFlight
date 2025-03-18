import XCTest
@testable import LiveFlight

class FavoritesViewModelTests: XCTestCase {
    
    var viewModel: FavoritesViewModel!
    var mockCoreDataManager: MockCoreDataManager!
    
    override func setUp() {
        super.setUp()
        // Mock Core Data Manager'ı oluşturuyoruz
        mockCoreDataManager = MockCoreDataManager()
        // ViewModel'i oluşturuyoruz
        viewModel = FavoritesViewModel(coreDataManager: mockCoreDataManager)
    }
    
    override func tearDown() {
        viewModel = nil
        mockCoreDataManager = nil
        super.tearDown()
    }
    
    func testAddFlightToFavorites() {
        // Test: Favorilere uçuş ekleme
        let flight = State(icao24: "ABC123", callSign: "FL123", longitude: -74.0060, latitude: 40.7128)
        
        // İlk başta uçuş favorilerde olmamalı
        XCTAssertFalse(viewModel.isFlightInFavorites(flight))
        
        // Uçuşu favorilere ekliyoruz
        viewModel.addFlightToFavorites(flight)
        
        // Uçuş favorilere eklenmiş olmalı
        XCTAssertTrue(viewModel.isFlightInFavorites(flight))
        XCTAssertEqual(viewModel.favoriteFlights.count, 1) // Favorilerde bir uçuş olmalı
    }
    
    func testRemoveFlightFromFavorites() {
        // Test: Favorilerden uçuş kaldırma
        let flight = State(icao24: "XYZ456", callSign: "FL456", longitude: -0.1278, latitude: 51.5074)
        
        // Uçuşu favorilere ekleyelim
        viewModel.addFlightToFavorites(flight)
        
        // Uçuşu favorilerden çıkarıyoruz
        viewModel.removeFlightFromFavorites(flight)
        
        // Uçuş favorilerde olmamalı
        XCTAssertFalse(viewModel.isFlightInFavorites(flight))
        XCTAssertEqual(viewModel.favoriteFlights.count, 0) // Favorilerde hiç uçuş olmamalı
    }
    
    func testLoadFavorites() {
        // Test: Favori uçuşları yükleme
        let flight1 = State(icao24: "ABC123", callSign: "FL123", longitude: -74.0060, latitude: 40.7128)
        let flight2 = State(icao24: "DEF456", callSign: "FL456", longitude: -0.1278, latitude: 51.5074)
        
        // İki uçuşu favorilere ekleyelim
        viewModel.addFlightToFavorites(flight1)
        viewModel.addFlightToFavorites(flight2)
        
        // Favori uçuşlar doğru şekilde yüklendi mi?
        XCTAssertEqual(viewModel.favoriteFlights.count, 2)
        XCTAssertTrue(viewModel.favoriteFlights.contains { $0.icao24 == "ABC123" })
        XCTAssertTrue(viewModel.favoriteFlights.contains { $0.icao24 == "DEF456" })
    }
    
    func testIsFlightInFavorites() {
        // Test: Favorilerdeki uçuşları kontrol etme
        let flight = State(icao24: "GHI789", callSign: "FL789", longitude: 13.405, latitude: 52.52)
        
        // İlk başta uçuş favorilerde olmamalı
        XCTAssertFalse(viewModel.isFlightInFavorites(flight))
        
        // Uçuşu favorilere ekleyelim
        viewModel.addFlightToFavorites(flight)
        
        // Uçuş favorilere eklenmiş olmalı
        XCTAssertTrue(viewModel.isFlightInFavorites(flight))
    }
}
