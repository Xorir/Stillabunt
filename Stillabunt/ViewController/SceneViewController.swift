//
//  ViewController.swift
//  Stillabunt
//
//  Created by Lord Summerisle on 2/4/18.
//  Copyright © 2018 ErmanMaris. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseDatabase
import ARKit

class SceneViewController: UIViewController, CLLocationManagerDelegate {
    
    private struct Constants {
        static let coordinate = "coordinate"
        static let padding: CGFloat = 16.0
    }
    
 
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    let locationManager = CLLocationManager()
    var latitude: CLLocationDegrees? = nil
    var longitude: CLLocationDegrees? = nil
    var firebaseReference: DatabaseReference?
    
    @IBOutlet weak var presentCreatePostButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        sceneView.session.run(configuration)
        
        firebaseReference = Database.database().reference()
        
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        readLocationData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentCreatePostButton.tintColor = .purple
    }
    
    @IBAction func presentCreatePost(_ sender: UIBarButtonItem) {
        let createPostViewController = CreatePostViewController()
        self.navigationController?.pushViewController(createPostViewController, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationCoordinates: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        LocationManager.sharedInstance.latitude = locationCoordinates.latitude
        LocationManager.sharedInstance.longitude = locationCoordinates.longitude
        locationManager.stopUpdatingLocation()
        reverseGeocoding(latitude: locationCoordinates.latitude, longitude: locationCoordinates.longitude)
    }
    
    func saveLocationToFirebase(lat: CLLocationDegrees?, long: CLLocationDegrees?) {
        if let latitude = lat, let longitude = long {
            firebaseReference?.child("coordinate").childByAutoId().setValue(["lat": "\(latitude)", "long": "\(longitude)"])
        }
    }
    
    func readLocationData() {
        firebaseReference?.child("coordinate").observeSingleEvent(of: .value , with: { (snapshot) in
            print(snapshot)
            guard let straySnapshot = snapshot.value as? [String: AnyObject] else { return }
            
            var keko = [NSDictionary]()
            keko.append(straySnapshot as NSDictionary)
            var strayArray = [Message]()
            
            for (_, value) in straySnapshot {
                let strayAnimal = Message(userDictionary: value as! NSDictionary)
                guard let strayAni = strayAnimal else { return }
                strayArray.append(strayAni)
                if let message = strayArray.first?.message {
                    self.createARMessage(message: message)
                }
            }
        })
    }
    
    public func reverseGeocoding(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { [weak self] (placemarks, error) -> Void in
            guard let strongSelf = self else { return }
            
            if error != nil {
                return
            } else {
                if let placeMark = placemarks?.first {
                    LocationManager.sharedInstance.postalCode = placeMark.postalCode
                    LocationManager.sharedInstance.administrativeArea = placeMark.administrativeArea
                    LocationManager.sharedInstance.locality = placeMark.locality
                    LocationManager.sharedInstance.areaOfInterest = placeMark.areasOfInterest?.first
                    LocationManager.sharedInstance.name = placeMark.name
                    LocationManager.sharedInstance.thoroughfare = placeMark.thoroughfare
                    LocationManager.sharedInstance.country = placeMark.country
                }
            }
        })
    }
    
    func center(node: SCNNode) {
        let (min, max) = node.boundingBox
        
        let dx = min.x + 0.5 * (max.x - min.x)
        let dy = min.y + 0.5 * (max.y - min.y)
        let dz = min.z + 0.5 * (max.z - min.z)
        node.pivot = SCNMatrix4MakeTranslation(dx, dy, dz)
        
        let action = SCNAction.rotateBy(x: 0, y: CGFloat(2 * Double.pi), z: 0, duration: 10)
        let repAction = SCNAction.repeatForever(action)
        node.runAction(repAction, forKey: "myrotate")
    }
    
    func createARMessage(message: String) {
        let pyramid = SCNNode(geometry: SCNText(string: message, extrusionDepth: 1.0))
        // use to get node type
        // print("darn node \(pyramid.geometry?.classForCoder)")
        pyramid.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        pyramid.position = SCNVector3Make(0, 0, 10.0)
        pyramid.scale = SCNVector3(0.1, 0.1,0.1)
        sceneView.scene.rootNode.addChildNode(pyramid)
        center(node: pyramid)
    }
    
    func calculateDistanceOfARObject(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> (xPosition: Double, zPosition: Double){
        if let lat = LocationManager.sharedInstance.latitude, let long = LocationManager.sharedInstance.longitude {
            var x = lat - latitude
            var z = long - longitude
            return (x, z)
        }
        return (0, 0)
    }
}

