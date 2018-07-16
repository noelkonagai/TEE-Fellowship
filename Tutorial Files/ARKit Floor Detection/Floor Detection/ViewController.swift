//
//  ViewController.swift
//  Floor Detection
//
//  Created by Noel Konagai on 12/8/17.
//  Copyright © 2017 Noel Konagai. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate{
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        self.configuration.planeDetection = .horizontal
        self.sceneView.session.run(configuration)
        self.sceneView.delegate = self
//        let planeNode = createSurface()
//        self.sceneView.scene.rootNode.addChildNode(planeNode)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createSurface(planeAnchor: ARPlaneAnchor) -> SCNNode{
        let planeNode = SCNNode(geometry: SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(CGFloat(planeAnchor.extent.z))))
        planeNode.geometry?.firstMaterial?.diffuse.contents = UIColor.cyan
        planeNode.geometry?.firstMaterial?.transparency  = 0.3
        planeNode.geometry?.firstMaterial?.isDoubleSided = true
        planeNode.position = SCNVector3(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z)
        planeNode.eulerAngles = SCNVector3(90.degreesToRadians, 0, 0)
        return planeNode
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        let planeNode = createSurface(planeAnchor: planeAnchor)
        node.addChildNode(planeNode)
        print("flat surface detected")
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        print("updating floor anchor")
        node.enumerateChildNodes { (childNode, _) in
            childNode.removeFromParentNode()
        }
        let planeNode = createSurface(planeAnchor: planeAnchor)
        node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        node.enumerateChildNodes { (childNode, _) in
            childNode.removeFromParentNode()
        }
        print("removed duplicate anchor")
    }


}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi/180}
}


