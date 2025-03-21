import XCTest
import Network
@testable import LiveFlight

// Mock Network Monitor Sınıfı
class MockNetworkMonitor: NetworkMonitor {
    
    override init() {
        super.init()
    }
    
    func simulateConnection(status: NWPath.Status) {
        isConnected = (status == .satisfied) // Bağlantı durumu belirleniyor
    }
}

class NetworkMonitorTests: XCTestCase {
    
    var networkMonitor: MockNetworkMonitor!
    
    override func setUp() {
        super.setUp()
        networkMonitor = MockNetworkMonitor()
    }
    
    override func tearDown() {
        networkMonitor = nil
        super.tearDown()
    }
    
    // İnternet bağlantısı varsa isConnected = true olmalı
    func testNetworkMonitor_WhenConnected_ShouldSetIsConnectedToTrue() {
        let expectation = self.expectation(description: "Bağlantı durumu güncellenmeli")
        
        networkMonitor.connectionStatusChanged = { isConnected in
            XCTAssertTrue(isConnected, "İnternet bağlantısı varken isConnected false dönmemeli!")
            expectation.fulfill()
        }
        
        networkMonitor.simulateConnection(status: .satisfied) // Bağlantı varmış gibi simüle ediyoruz
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    // İnternet bağlantısı yoksa isConnected = false olmalı
    func testNetworkMonitor_WhenDisconnected_ShouldSetIsConnectedToFalse() {
        let expectation = self.expectation(description: "Bağlantı durumu güncellenmeli")
        
        networkMonitor.connectionStatusChanged = { isConnected in
            XCTAssertFalse(isConnected, "İnternet bağlantısı yokken isConnected true dönmemeli!")
            expectation.fulfill()
        }
        
        networkMonitor.simulateConnection(status: .unsatisfied) // Bağlantı yokmuş gibi simüle ediyoruz
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    // Bağlantı durumu değiştiğinde closure tetiklenmeli
    func testNetworkMonitor_WhenStatusChanges_ShouldTriggerClosure() {
        let expectation = self.expectation(description: "Bağlantı durumu değiştiğinde closure çağrılmalı")
        
        var closureCalled = false
        
        networkMonitor.connectionStatusChanged = { _ in
            closureCalled = true
            expectation.fulfill()
        }
        
        networkMonitor.simulateConnection(status: .satisfied) // Durumu değiştiriyoruz
        
        waitForExpectations(timeout: 2, handler: nil)
        XCTAssertTrue(closureCalled, "connectionStatusChanged closure'ı çağrılmadı!")
    }
}
