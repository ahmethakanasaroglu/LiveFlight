//
//  MapKitManager.swift
//  LiveFlight
//
//  Created by Ahmet Hakan Asaroğlu on 14.03.2025.
//

import MapKit
import CoreLocation

protocol MapKitManagerDelegate: AnyObject {
    func didUpdateUserLocation(_ location: CLLocation)
    func didUpdateMapType(_ mapType: MKMapType)
}

class MapKitManager: NSObject, CLLocationManagerDelegate, MKMapViewDelegate {
    static var shared = MapKitManager()
    
    var locationManager: CLLocationManager?
    weak var delegate: MapKitManagerDelegate?
    private var favoriteFlights: Set<String> = []
    var flightsModel: [State] = []
    var favoritesViewModel = FavoritesViewModel()
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
    }
    
    // Annotations eklemek için fonksiyon (Sadece ekran içindekileri ekler)
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let visibleRegion = mapView.region
        let minLat = visibleRegion.center.latitude - (visibleRegion.span.latitudeDelta / 2)
        let maxLat = visibleRegion.center.latitude + (visibleRegion.span.latitudeDelta / 2)
        let minLon = visibleRegion.center.longitude - (visibleRegion.span.longitudeDelta / 2)
        let maxLon = visibleRegion.center.longitude + (visibleRegion.span.longitudeDelta / 2)

        let visibleFlights = flightsModel.filter { flight in
            guard let lat = flight.latitude, let lon = flight.longitude else { return false }
            return lat >= minLat && lat <= maxLat && lon >= minLon && lon <= maxLon
        }

        addAnnotations(to: mapView, with: visibleFlights)
    }

    // Annotations eklemek için fonksiyon
    func addAnnotations(to mapView: MKMapView, with flights: [State]) {
        mapView.removeAnnotations(mapView.annotations) // Eski annotation'ları temizle
     
        for flight in flights {
            if let latitude = flight.latitude, let longitude = flight.longitude {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
                flightsModel.append(flight)
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    // annotation'a özel görsel ekleme
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "FlightAnnotation"
        
        if annotation is MKUserLocation {
            return nil // Kullanıcının konumu için özel bir görünüm atama
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.image = UIImage(named: "plane_icon")?.withTintColor(.yellow, renderingMode: .alwaysOriginal) // Uçak simgesi
            annotationView?.tintColor = .yellow
            annotationView?.frame.size = CGSize(width: 20, height: 20) // Simge boyutu
        } else {
            annotationView?.annotation = annotation
        }
        
        // Uçağın yönünü ayarla
        if let flight = flightsModel.first(where: { $0.latitude == annotation.coordinate.latitude && $0.longitude == annotation.coordinate.longitude }),
           let trueTrack = flight.trueTrack {
            annotationView?.updateRotation(with: CLLocationDegrees(trueTrack))
        }
        
        return annotationView
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        
        if let flight = flightsModel.first(where: { $0.latitude == annotation.coordinate.latitude && $0.longitude == annotation.coordinate.longitude }) {
            let detailVC = BottomSheetViewController()
            detailVC.flight = flight
            
            if let topVC = UIApplication.shared.windows.first?.rootViewController {
                topVC.presentPanModal(detailVC)
            }
        }
        
        
    }
    

    /// **Konum İzni İsteme**
    func requestLocationPermission() {
        guard let locationManager = locationManager else {return}
        
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .notDetermined:
            print("Konum izni isteniyor...")
            locationManager.requestWhenInUseAuthorization()
            
        case .denied, .restricted:
            print("Konum izni reddedilmiş! Kullanıcıyı ayarlara yönlendiriyorum...")
            showSettingsAlert()
            
        case .authorizedWhenInUse, .authorizedAlways:
            print("Konum izni zaten verilmiş.")
            locationManager.startUpdatingLocation()
            
        @unknown default:
            print("Bilinmeyen yetki durumu!")
        }
    }
    
    /// **Konum izni değiştiğinde ne olacağını belirler**
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            print("Kullanıcı konum izni verdi, güncelleniyor...")
            locationManager?.startUpdatingLocation()
            
        case .denied:
            print("Kullanıcı konum iznini reddetti, ayarlara yönlendir...")
            showSettingsAlert()
            
        case .restricted:
            print("Konum izni kısıtlanmış, işlem yapılamaz.")
            
        default:
            break
        }
    }
    
    /// **Kullanıcının manuel olarak ayarları açmasını sağlar**
    func showSettingsAlert() {
        let alert = UIAlertController(
            title: "Konum İzni Gerekli",
            message: "Uygulamanın konumunuzu kullanabilmesi için lütfen ayarlardan izin verin.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Ayarları Aç", style: .default, handler: { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Vazgeç", style: .cancel))
        
        if let topVC = UIApplication.shared.windows.first?.rootViewController {
            topVC.present(alert, animated: true)
        }
    }
    
    
    
    /// **Kullanıcının konumunu güncellemeye başlar**
    func startUpdatingLocation() {
        guard CLLocationManager.locationServicesEnabled() else {
            print("Konum servisleri kapalı!")
            return
        }
        
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager?.startUpdatingLocation()
        } else {
            requestLocationPermission()
        }
    }
    
    /// **Kullanıcının konumu değiştikçe güncelleme yapar**
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else { return }
        delegate?.didUpdateUserLocation(userLocation)
        
    }
    
    /// **Harita tipini değiştirir**
    func changeMapType(to mapType: MKMapType) {
        delegate?.didUpdateMapType(mapType)
    }
}

extension MKAnnotationView {
    
    func updateRotation(with trueTrack: CLLocationDegrees) {
        let rotationAngle = CGFloat(trueTrack * .pi / 270) // Dereceyi radyana çevir  // başta 180'di. derece düzeltildi.
        self.transform = CGAffineTransform(rotationAngle: rotationAngle)
    }
}




