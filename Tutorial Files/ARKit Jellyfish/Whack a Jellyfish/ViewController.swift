//
//  ViewController.swift
//  Whack a Jellyfish
//
//  Created by Noel Konagai on 12/6/17.
//  Copyright © 2017 Noel Konagai. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.session.run(configuration)
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func play(_ sender: Any) {
        self.addNode()
    }
    
    @IBAction func reset(_ sender: Any) {
    }
    
    
    func addNode() {
        let jellyFishScene = SCNScene(named: "art.scnassets/Jellyfish.scn")
        let jellyFishNode = jellyFishScene?.rootNode.childNode(withName: "Jellyfish", recursively: false)
        
        jellyFishNode?.position = SCNVector3(0,0,-2)
        self.sceneView.scene.rootNode.addChildNode(jellyFishNode!)
        
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let sceneViewTappedOn = sender.view as! SCNView
        let touchCoordinates = sender.location(in: sceneViewTappedOn)
        let hitTest = sceneViewTappedOn.hitTest(touchCoordinates)
        if hitTest.isEmpty {
            print("did not touch anything")
        } else {
            let results  = hitTest.first
            let geometry = results?.node.geometry
            print(geometry ?? "wut")
        }
    }


}

