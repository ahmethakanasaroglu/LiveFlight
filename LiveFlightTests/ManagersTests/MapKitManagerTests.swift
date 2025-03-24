import XCTest
import MapKit
import CoreLocation
@testable import LiveFlight

class MapKitManagerTests: XCTestCase {
    
    var mapKitManager: MapKitManager!
    var mockDelegate: MockMapKitManagerDelegate!
    var mockLocationManager: MockCLLocationManager!
    var mockMapView: MockMKMapView!
    
    override func setUp() {
        super.setUp()
        
        // Initializing objects
        mapKitManager = MapKitManager()
        mockDelegate = MockMapKitManagerDelegate()
        mapKitManager.delegate = mockDelegate
        
        mockLocationManager = MockCLLocationManager()
        mapKitManager.locationManager = mockLocationManager
        
        mockMapView = MockMKMapView()
    }
    
    override func tearDown() {
        mapKitManager = nil
        mockDelegate = nil
        mockLocationManager = nil
        mockMapView = nil
        super.tearDown()
    }
    
    func testRegionDidChangeAnimated() {
        // Arrange
        let flight = State(longitude: -75.0, latitude: 40.0)
        mapKitManager.flightsModel = [flight]
        
        let visibleRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 40.0, longitude: -75.0),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
        mockMapView.region = visibleRegion
        
        // Act
        mapKitManager.mapView(mockMapView, regionDidChangeAnimated: true)
        
        // Assert
        XCTAssertEqual(mockMapView.addAnnotationCalls.count, 1)
        XCTAssertEqual(mockMapView.addAnnotationCalls.first?.coordinate.latitude, 40.0)
        XCTAssertEqual(mockMapView.addAnnotationCalls.first?.coordinate.longitude, -75.0)
    }
    
    
    func testAddAnnotations() {
        // Mock data
        let flight = State(
            icao24: "ICAO123",
            callSign: "Flight123",
            originCountry: "Country",
            longitude: -74.0060, latitude: 40.7128,
            trueTrack: 180
        )
        
        mapKitManager.flightsModel = [flight]
        
        // Call addAnnotations
        mapKitManager.addAnnotations(to: mockMapView, with: [flight])
        
        // Verify if the annotation was added
        XCTAssertEqual(mockMapView.addAnnotationCalls.count, 1)
        let annotation = mockMapView.addAnnotationCalls.first
        XCTAssertNotNil(annotation)
        XCTAssertEqual(annotation?.coordinate.latitude, 40.7128)
        XCTAssertEqual(annotation?.coordinate.longitude, -74.0060)
    }
    
    func testAnnotationView() {
        // Arrange
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 40.0, longitude: -75.0)
        
        let flight = State(longitude: -75.0, latitude: 40.0)
        mapKitManager.flightsModel = [flight]
        
        // Act
        let annotationView = mapKitManager.mapView(mockMapView, viewFor: annotation)
        
        // Assert
        XCTAssertNotNil(annotationView)
        XCTAssertEqual(annotationView?.image, UIImage(named: "plane_icon")?.withTintColor(.yellow, renderingMode: .alwaysOriginal))
    }
    
    
    
    
    func testStartUpdatingLocationWithPermissionGranted() {
        // Simulate location services enabled and permission granted
        MockCLLocationManager.shared.setMockAuthorizationStatus(.authorizedWhenInUse)
        
        // Call startUpdatingLocation
        mapKitManager.startUpdatingLocation()
        
        // Verify if locationManager's startUpdatingLocation method is called
        XCTAssertTrue(mockLocationManager.startUpdatingLocationCalled)
    }
    
    func testStartUpdatingLocationWithPermissionDenied() {
        // Simulate location services enabled and permission denied
        MockCLLocationManager.shared.setMockAuthorizationStatus(.denied)
        
        // Call startUpdatingLocation
        mapKitManager.startUpdatingLocation()
        
        // Verify if the requestLocationPermission is called
        XCTAssertFalse(mockLocationManager.requestLocationPermissionCalled)
    }
    
    
    func testLocationManagerDidUpdateLocation() {
        // Simulate location update
        let mockLocation = CLLocation(latitude: 40.7128, longitude: -74.0060)
        
        // Call didUpdateLocations
        mapKitManager.locationManager(mockLocationManager, didUpdateLocations: [mockLocation])
        
        // Verify if the delegate's didUpdateUserLocation method is called
        XCTAssertTrue(mockDelegate.didUpdateUserLocationCalled)
        XCTAssertEqual(mockDelegate.userLocation?.coordinate.latitude, 40.7128)
        XCTAssertEqual(mockDelegate.userLocation?.coordinate.longitude, -74.0060)
    }
    
    func testShowSettingsAlert() {
        // Arrange
        let alertController = UIAlertController(title: "Konum İzni Gerekli", message: "Uygulamanın konumunuzu kullanabilmesi için lütfen ayarlardan izin verin.", preferredStyle: .alert)
        
        // Act
        mapKitManager.showSettingsAlert()
        
        // Assert
        XCTAssertNotNil(alertController)
    }
    
    
    func testChangeMapType() {
        // Call changeMapType
        let mapType: MKMapType = .satellite
        mapKitManager.changeMapType(to: mapType)
        
        // Verify if the delegate's didUpdateMapType method is called
        XCTAssertTrue(mockDelegate.didUpdateMapTypeCalled)
        XCTAssertEqual(mockDelegate.mapType, mapType)
    }
}

// MARK: - Mocks

class MockMapKitManagerDelegate: MapKitManagerDelegate {
    var didUpdateUserLocationCalled = false
    var userLocation: CLLocation?
    
    var didUpdateMapTypeCalled = false
    var mapType: MKMapType?
    
    func didUpdateUserLocation(_ location: CLLocation) {
        didUpdateUserLocationCalled = true
        userLocation = location
    }
    
    func didUpdateMapType(_ mapType: MKMapType) {
        didUpdateMapTypeCalled = true
        self.mapType = mapType
    }
}

class MockCLLocationManager: CLLocationManager {
    private var mockAuthorizationStatus: CLAuthorizationStatus = .notDetermined
    
    var startUpdatingLocationCalled = false
    var requestLocationPermissionCalled = false
    
    // Computed property ile mock edilmiş authorizationStatus
    override class func authorizationStatus() -> CLAuthorizationStatus {
        return MockCLLocationManager.shared.mockAuthorizationStatus
    }
    
    static let shared = MockCLLocationManager()  // Singleton deseni kullanarak örnek alıyoruz
    
    // Dışarıdan testlerde durumu değiştirebilmek için setter metodunu ekleyebiliriz
    func setMockAuthorizationStatus(_ status: CLAuthorizationStatus) {
        mockAuthorizationStatus = status
    }
    
    override func startUpdatingLocation() {
        startUpdatingLocationCalled = true
    }
    
    override func requestWhenInUseAuthorization() {
        requestLocationPermissionCalled = true
    }
    
}


class MockMKMapView: MKMapView {
    var addAnnotationCalls: [MKAnnotation] = []
    
    override func addAnnotation(_ annotation: MKAnnotation) {
        addAnnotationCalls.append(annotation)
    }
}
