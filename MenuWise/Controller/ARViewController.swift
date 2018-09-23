//
//  ARViewController.swift
//  MenuWise
//
//  Created by thomas minshull on 2018-09-22.
//  Copyright © 2018 thomas minshull. All rights reserved.
//

import UIKit
import ARKit
import SceneKit
import CoreLocation

class ARViewController: UIViewController {
    private struct SegueIDs {
        static let newFishSegue = "NewFishSegue"
        static let invalidLogoSegue = "invalidLogoSegue"
    }
    
    @IBOutlet var arscene: ARSCNView!
    let networkManager = NetworkManager()
    let locationManager = CLLocationManager()
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var location: CLLocation?
    
    private var trackingImages = Set<ARReferenceImage>()
    let oceanWiseLogo = UIImage(named: "oceanWiseLogo")!
    let mealShare = UIImage(named: "MealWiseLogo")!
    
    var oceanWiseRef: ARReferenceImage!
    var mealWiseRef: ARReferenceImage!
    var logos: Set<ARReferenceImage>!
    
    var configuration: ARImageTrackingConfiguration {
        let config = ARImageTrackingConfiguration()
        config.trackingImages = logos
        config.maximumNumberOfTrackedImages = 10
        return config
    }
    
//    let mealShareRef = ARReferenceImage(mealShare, orientation: .up, physicalWidth: 5.0)
//    let logos = ARReferenceImage.referenceImages(inGroupNamed: "logos", bundle: nil)!
    var oceanWiseNode: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        arscene.delegate = self
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Show statistics such as fps and timing information
        arscene.showsStatistics = true
        arscene.scene = SCNScene()
        
        oceanWiseRef = ARReferenceImage(oceanWiseLogo.cgImage!, orientation: .up, physicalWidth: 5.0)
        mealWiseRef = ARReferenceImage(mealShare.cgImage!, orientation: .up, physicalWidth: 5.0)
        logos = Set(arrayLiteral: oceanWiseRef, mealWiseRef)
         self.arscene.session.run(configuration)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     //   self.arscene.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
   //     self.arscene.session.pause()
    }
}

extension ARViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        defer {
            location = locations.first
        }
        if location == nil {
            self.arscene.session.run(configuration)
            activityIndicator.stopAnimating()
            print("Locations")
        }
    }
}

extension ARViewController: ARSCNViewDelegate {
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            if imageAnchor.referenceImage == oceanWiseRef {
                print("Ocean WISE!!!")
                if let location = location {
                    networkManager.validateOceanWiseLogo(location: location) { [weak self] (success) in
                        let identifer = true ? SegueIDs.newFishSegue : SegueIDs.invalidLogoSegue
                        DispatchQueue.main.async {
                            self?.performSegue(withIdentifier: identifer, sender: nil)
                        }
                    }
                }
            } else if imageAnchor.referenceImage == mealWiseRef {
                print("Meal Share")
                let location = CLLocation(latitude: 0.00, longitude: 0.00)
                    
                networkManager.validateOceanWiseLogo(location: location) { [weak self] (success) in
                    let identifer = false ? SegueIDs.newFishSegue : SegueIDs.invalidLogoSegue
                    DispatchQueue.main.async {
                        self?.performSegue(withIdentifier: identifer, sender: nil)
                    }
                }
            }
        }
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
   
    }
}
