import XCTest
import CoreData
@testable import LiveFlight // Burayı kendi proje modül adınla değiştir

class CoreDataManagerTests: XCTestCase {
    var coreDataManager: CoreDataManager!
    var mockPersistentContainer: NSPersistentContainer!  // testlerde kalıcı veri kaydedilmesini önlemek için

    override func setUp() {
        super.setUp()
        
        mockPersistentContainer = NSPersistentContainer(name: "CoreData")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType // Testler için bellek içi Core Data kullan
        
        mockPersistentContainer.persistentStoreDescriptions = [description]
        mockPersistentContainer.loadPersistentStores { (_, error) in
            XCTAssertNil(error, "Core Data yüklenirken hata oluştu: \(error?.localizedDescription ?? "")")
        }
        
        coreDataManager = CoreDataManager()
        coreDataManager.persistentContainer = mockPersistentContainer
    }
    
    override func tearDown() {
        coreDataManager = nil
        mockPersistentContainer = nil
        super.tearDown()
    }
    
    func testAddFlightToFavorites() {
        let flight = State(icao24: "ABC123", callSign: "TEST123", longitude: 8.0, latitude: 50.0)
        coreDataManager.addFlightToFavorites(flight)
        
        // verinin gerçekten kaydedildigini dogrular aşağıda
        let favorites = coreDataManager.fetchFavoriteFlights()
        XCTAssertEqual(favorites.count, 1)
        XCTAssertEqual(favorites.first?.icao24, "ABC123")
        XCTAssertEqual(favorites.first?.callSign, "TEST123")
    }
    
    func testRemoveFlightFromFavorites() {
        let flight = State(icao24: "DEF456", callSign: "TEST456", longitude: 7.0, latitude: 40.0)
        coreDataManager.addFlightToFavorites(flight) // önce eklicek ki silsin
        coreDataManager.removeFlightFromFavorites(flight)
        
        let favorites = coreDataManager.fetchFavoriteFlights()
        XCTAssertTrue(favorites.isEmpty) // silinince bos oldugu dogrulanır
    }
    
    func testFetchFavoriteFlights() {
        let flight1 = State(icao24: "GHI789", callSign: "FLIGHT1", longitude: 9.0, latitude: 45.0)
        let flight2 = State(icao24: "JKL012", callSign: "FLIGHT2", longitude: 10.0, latitude: 46.0)
        // iki uçuş girip altta ekledik
        coreDataManager.addFlightToFavorites(flight1)
        coreDataManager.addFlightToFavorites(flight2)
        // altta eklenip cekildiginde 2 tane geldigini düzgün test ettik
        let favorites = coreDataManager.fetchFavoriteFlights()
        XCTAssertEqual(favorites.count, 2)
    }
    
    func testIsFlightInFavorites() {
        let flight = State(icao24: "MNO345", callSign: "TEST789", longitude: 11.0, latitude: 47.0)
        coreDataManager.addFlightToFavorites(flight)
        // üstte favorilere ekledik, altta favorilerde olup olmadıgını test ettik
        XCTAssertTrue(coreDataManager.isFlightInFavorites(flight))
    }
    
    func testIsFlightNotInFavorites() {
        let flight = State(icao24: "PQR678", callSign: "TEST101", longitude: 12.0, latitude: 48.0)
        // üstte favorilere ekledik, altta favorilerde olup olmadıgını test ettik
        XCTAssertFalse(coreDataManager.isFlightInFavorites(flight))
    }
    
    func testSaveContext() {
        let flight = State(icao24: "XYZ999", callSign: "TEST_SAVE", longitude: 13.0, latitude: 52.0)
        coreDataManager.addFlightToFavorites(flight)
        // ucus olusturup ekledik.
        let fetchRequest: NSFetchRequest<FlightEntity> = FlightEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "icao24 == %@", "XYZ999") // icao24'ü XYZ999 olan nesneleri filtreler.
        
        // coreData'dan manual olarak veriyi sorgular
        do {
            let results = try coreDataManager.context.fetch(fetchRequest)
            XCTAssertEqual(results.count, 1)
            XCTAssertEqual(results.first?.icao24, "XYZ999")
        } catch {
            XCTFail("Veri kaydetme başarısız: \(error.localizedDescription)")
        }
        // kaydetmenin basarılı olup olmadıgını icao24 kodu ile kontrol eder.
    }

}
