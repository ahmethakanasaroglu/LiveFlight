import XCTest
import MapKit
import CoreLocation
@testable import LiveFlight

class HomeScreenViewModelTests: XCTestCase {
    
    var viewModel: HomeScreenViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = HomeScreenViewModel()
    }
    
    override func tearDown() {  // viewModel'ı sıfırlar her test sonrası, bellek için önemli
        viewModel = nil
        super.tearDown()
    }
    
    func testObserveInternetConnection() {
        let expectation = expectation(description: "Internet status should change")
        
        viewModel.onInternetStatusChanged = { isConnected, message in
            XCTAssertFalse(isConnected) // Simule edilen senaryoda internet bağlantısı yok
            XCTAssertEqual(message, "İnternet bağlantınız yok!")
            expectation.fulfill()
        }
        
        NetworkMonitor.shared.connectionStatusChanged?(false)
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testCheckInternetConnection_NoConnection() {
        let expectation = self.expectation(description: "Bağlantı yok uyarısı verildi")
        
        NetworkMonitor.shared.isConnected = false
        
        viewModel.onInternetStatusChanged = { isConnected, statusText in
            XCTAssertFalse(isConnected)  // bağlantı olmaması durumu
            XCTAssertEqual(statusText, "İnternet bağlantınız yok! Çıkış Yapılıyor.")
            expectation.fulfill()
        }
        
        viewModel.checkInternetConnection()
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testFetchFlightData_Success() {
        let expectation = self.expectation(description: "API verisi başarıyla alındı")
        
        viewModel.flightData = { data in
            XCTAssertNotNil(data, "Veri nil olmamalı")
            expectation.fulfill()  // API'den veri başarıyla gelirse test tamamlanır
        }
        
        viewModel.fetchFlightData()
        
        waitForExpectations(timeout: 20.0, handler: nil) // testin bekleme saniyesi
        // ŞU AN SİTE ERROR VERİYOR SONRA DENİCEM BİR DAHA, TEST DOGRU OLMALI
    }
    
    func testStopUpdatingFlightData() {
        viewModel.stopUpdatingFlightData()
        XCTAssertNil(viewModel.timer, "Timer iptal edilmeli")
    }
    
    func testDidUpdateUserLocation() {
        let expectation = self.expectation(description: "Kullanıcı konumu güncellendi")
        let mockLocation = CLLocation(latitude: 40.7128, longitude: -74.0060)
        
        viewModel.userLocation = { location in
            XCTAssertEqual(location.coordinate.latitude, mockLocation.coordinate.latitude)
            XCTAssertEqual(location.coordinate.longitude, mockLocation.coordinate.longitude)
            expectation.fulfill()
        }
        
        viewModel.didUpdateUserLocation(mockLocation)
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testDidUpdateMapType() {
        let expectation = expectation(description: "Harita türü güncellenmelidir")
        
        viewModel.mapType = { mapType in
            XCTAssertEqual(mapType, .satellite)
            expectation.fulfill()
        }
        
        viewModel.didUpdateMapType(.satellite)
        wait(for: [expectation], timeout: 1.0)
    }
    
    
    // updateMapType fonksiyonunun gerçekten MapKitManager'i çağırdığını test ediyoruz.
    func testUpdateMapType() {
        var mockMapKitManager = MockMapKitManager()
        MapKitManager.shared = mockMapKitManager
        
        viewModel.updateMapType(to: .hybrid) // changeMapType(to:) metodunu çağırmasını sağlamaya calısıyoruz
        
        XCTAssertEqual(mockMapKitManager.updatedMapType, .hybrid)
        // MapKitManager'in gerçekte MapKit’i değiştirmesini istemiyoruz. Gerçek MapKitManager yerine "Mock" bir versiyonunu kullanıyoruz.
    }
}

class MockMapKitManager: MapKitManager {
    var updatedMapType: MKMapType?
    // updatedMapType değişkeni, hangi harita türüne güncellendiğini takip eder. Bu sayede MapKitManager'ı degistirmeden test edebiliyoruz.

    override func changeMapType(to mapType: MKMapType) {
        updatedMapType = mapType
    }
}

