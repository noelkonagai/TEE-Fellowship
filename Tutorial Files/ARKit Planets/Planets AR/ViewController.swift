//
//  ViewController.swift
//  Planets AR
//
//  Created by Noel Konagai on 12/5/17.
//  Copyright © 2017 Noel Konagai. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        self.sceneView.session.run(configuration)
        self.sceneView.autoenablesDefaultLighting = true
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let sun = SCNNode()
        let earthParent = SCNNode()
        let venusParent = SCNNode()
        let moonParent = SCNNode()
        
        sun.geometry =  SCNSphere(radius: 0.35)
        sun.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "SunDiffuse")
        sun.position = SCNVector3(0,0,-1)
        
        earthParent.position = SCNVector3(0,0,-1)
        venusParent.position = SCNVector3(0,0,-1)
        moonParent.position = SCNVector3(1.2,0,0)
        
        self.sceneView.scene.rootNode.addChildNode(sun)
        self.sceneView.scene.rootNode.addChildNode(earthParent)
        self.sceneView.scene.rootNode.addChildNode(venusParent)
        
        let earth =  planet(geometry: SCNSphere(radius: 0.2), diffuse: #imageLiteral(resourceName: "EarthDay"), specular: #imageLiteral(resourceName: "EarthSpecular"), emission: #imageLiteral(resourceName: "EarthEmission"), normal: #imageLiteral(resourceName: "EarthNormal"), position: SCNVector3(1.2,0,0))
        let venus = planet(geometry: SCNSphere(radius: 0.3), diffuse: #imageLiteral(resourceName: "VenusDiffuse"), specular: nil, emission: #imageLiteral(resourceName: "VenusEmission"), normal: nil, position: SCNVector3(0.7,0,0))
        let moon = planet(geometry: SCNSphere(radius: 0.05), diffuse: #imageLiteral(resourceName: "MoonDiffuse"), specular: nil, emission: nil, normal: nil, position: SCNVector3 (0.5,0,0))
        
        sun.runAction(rotation(time: 8))
        earthParent.runAction(rotation(time: 12))
        venusParent.runAction(rotation(time: 16))
        earth.runAction(rotation(time: 10))
        moonParent.runAction(rotation(time: 8))
        
        earthParent.addChildNode(earth)
        venusParent.addChildNode(venus)
        earthParent.addChildNode(moonParent)
        earth.addChildNode(moon)
        moonParent.addChildNode(moon)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

func planet(geometry: SCNGeometry, diffuse: UIImage, specular: UIImage?, emission: UIImage?, normal: UIImage?, position: SCNVector3) -> SCNNode {
    let planet = SCNNode(geometry: geometry)
    planet.geometry?.firstMaterial?.diffuse.contents = diffuse
    planet.geometry?.firstMaterial?.specular.contents = specular
    planet.geometry?.firstMaterial?.emission.contents = emission
    planet.geometry?.firstMaterial?.normal.contents = normal
    planet.position = position
    return planet
}

func rotation(time: TimeInterval) -> SCNAction {
    let rotation = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: time)
    let forever = SCNAction.repeatForever(rotation)
    return forever
}

extension Int {
    
    var degreesToRadians: Double { return Double(self) *  .pi/180}
    
}

