import CoreData
import XCTest
@testable import LiveFlight

class MockCoreDataManager: CoreDataManager {
    var flightsInFavorites: [State] = []
    
    override func isFlightInFavorites(_ flight: State) -> Bool {
        return flightsInFavorites.contains { $0.icao24 == flight.icao24 }
    }
    
    override func addFlightToFavorites(_ flight: State) {
        flightsInFavorites.append(flight)
    }
    
    override func removeFlightFromFavorites(_ flight: State) {
        flightsInFavorites.removeAll { $0.icao24 == flight.icao24 }
    }
    
    override func fetchFavoriteFlights() -> [FlightEntity] {
        return flightsInFavorites.map { flight in
            let entity = FlightEntity(context: persistentContainer.viewContext)
            entity.icao24 = flight.icao24
            entity.callSign = flight.callSign
            entity.latitude = flight.latitude!
            entity.longitude = flight.longitude!
            return entity
        }
    }
}
