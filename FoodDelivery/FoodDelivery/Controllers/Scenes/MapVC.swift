import UIKit
import MapKit

class MapVC: UIViewController {
    let mapView = MKMapView()
    
    let locationManager = CLLocationManager()
    var lastLocation: CLLocation?
    var coordinate: Coordinate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        view.backgroundColor = .systemBackground
        mapView.delegate = self
        configureMapView()
        checkLocationServices()
        
    }
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(coordinate: Coordinate){
        super.init(nibName: nil, bundle: nil)
        self.coordinate = coordinate
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getCoordinate(){
        let lat = lastLocation?.coordinate.latitude
        let long = lastLocation?.coordinate.longitude
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: lat!, longitude: long!), addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude), addressDictionary: nil))
        request.requestsAlternateRoutes = true
        
        request.transportType = .automobile
        
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            for route in unwrappedResponse.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.mapView.showAnnotations([destinationAnnotation], animated: true )
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.systemBlue
        renderer.lineWidth = 4.0
        return renderer
    }
    
    private func configureMapView(){
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
    }
    
    func setupLocationManager() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
        
        func showUserLocationCenterMap() {
            if let location = locationManager.location?.coordinate {
                let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 100, longitudinalMeters: 100)
                mapView.setRegion(region, animated: true)
            }
        }
        
        func checkLocationServices() {
            if CLLocationManager.locationServicesEnabled() {
                setupLocationManager()
                checkLocationAuthorization()
            } else {
                //TODO: Kullanıcıya ayarlardan konum servisini açması istenebilir
            }
        }
        
        func checkLocationAuthorization() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse:
                trackingLocation()
            case .denied:
                break
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .authorizedAlways:
                break
            case .restricted:
                break
            }
        }
        
        
        func trackingLocation() {
            mapView.showsUserLocation = true
            showUserLocationCenterMap()
            locationManager.startUpdatingLocation()
            lastLocation = getCenterLocation(mapView: mapView)
            
        }
        
        func getCenterLocation(mapView: MKMapView) -> CLLocation {
            let latitude = mapView.centerCoordinate.latitude
            let longitude = mapView.centerCoordinate.longitude
            
            return CLLocation(latitude: latitude, longitude: longitude)
        }
    
}

extension MapVC: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
}

extension MapVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.lastLocation = locations[0]
        getCoordinate()
        
    }
}
