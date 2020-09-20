//
//  LocationViewController.swift
//  WijekoonWHMCB-COBSCCOMP191P-006
//
//  Created by Chathura Wijekoon on 9/19/20.
//  Copyright © 2020 Chathura Wijekoon. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class LocationViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var locationView: MKMapView!
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    
    let locationManager = CLLocationManager()
    
    let db = Firestore.firestore()
    
    var userDocRefId = ""
    
    var geoPoints: [GeoPoint] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Danger Areas"
        
        fetchUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationManager.stopUpdatingLocation()
            
            render(location)
            updateLocations(location)
        }
    }
    
    func render(_ location: CLLocation) {
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        locationView.setRegion(region, animated: true)
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        locationView.addAnnotation(pin)
    }
    
    func updateLocations(_ location: CLLocation) {
        if let email = Auth.auth().currentUser?.email {
            db.collection("users").whereField("email", isEqualTo: email).getDocuments { (querySnapshot, error) in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        self.userDocRefId = snapshotDocuments[0].documentID

                        self.db.collection("users").document(self.userDocRefId).updateData([
                            "location": GeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                        ]) { error in
                            if let e = error {
                                print(e)
                                return
                            }
                        }
                    }
                }
            }
        }
    }
    
    func fetchUsers() {
        geoPoints = []
        db.collection("user").addSnapshotListener { (querySnapshot, error) in
            if let e = error {
                print(e.localizedDescription)
            } else {

                if let snapshotDocuemnts = querySnapshot?.documents {
                    for doc in snapshotDocuemnts {
                        let data = doc.data()
                        if let geopoint = data["location"] as? GeoPoint {
                            self.geoPoints.append(geopoint)
                        }
                    }
                    DispatchQueue.main.async {
                        for i in self.geoPoints{
                            if let latitude = i.value(forKey: "latitude"), let longitude = i.value(forKey: "longitude") {
                                let point = MKPointAnnotation()
//                                let annotationView = MKMarkerAnnotationView()
//                                annotationView.markerTintColor = .black
//                                let point = ColorPointAnnotation(pinColor: .black)
                                point.coordinate = CLLocationCoordinate2D(latitude: latitude as! CLLocationDegrees, longitude: longitude as! CLLocationDegrees)
                                self.locationView.addAnnotation(point)
                            }

                        }
                    }
                }
            }
        }
    }
    
    
}
