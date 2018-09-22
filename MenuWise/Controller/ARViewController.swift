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

class ARViewController: UIViewController {
    @IBOutlet var arscene: ARSCNView!
    
    private var trackingImages = Set<ARReferenceImage>()
    let logos = ARReferenceImage.referenceImages(inGroupNamed: "logos", bundle: nil)!
    var oceanWiseNode: SCNNode?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        arscene.delegate = self
        
        // Show statistics such as fps and timing information
        arscene.showsStatistics = true
        
        arscene.scene = SCNScene()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = logos
        configuration.maximumNumberOfTrackedImages = logos.count
        self.arscene.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.arscene.session.pause()
    }
}

extension ARViewController: ARSCNViewDelegate {
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        //SCNNode
        
        
        
        print("Ocean WISE!!!")
        return nil
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
     
    }
}
