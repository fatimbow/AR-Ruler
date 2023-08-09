//
//  ViewController.swift
//  AR Ruler
//
//  Created by fatma y on 9.08.2023.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        guard let touchLocation = touches.first?.location(in: sceneView) else {return}
            
        guard let query = sceneView.raycastQuery(from: touchLocation, allowing: .estimatedPlane, alignment: .any) else {return}
        
        guard let result = sceneView.session.raycast(query).first else {return}
           
        addDot(at: result)
            
    }
    
    func addDot(at location: ARRaycastResult) {
        
       let dotGeometry = SCNSphere(radius: 0.005)
        
       let material = SCNMaterial()
        
        material.diffuse.contents = UIColor.red
        
        dotGeometry.materials = [material]
        
        let dotNode = SCNNode(geometry: dotGeometry)
        
        dotNode.position = SCNVector3(
            x: location.worldTransform.columns.3.x,
            y: location.worldTransform.columns.3.y,
            z: location.worldTransform.columns.3.z)
        
        sceneView.scene.rootNode.addChildNode(dotNode)
      
    }

}

