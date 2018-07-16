//
//  ViewController.swift
//  Object Placement
//
//  Created by Noel Konagai on 12/8/17.
//  Copyright © 2017 Noel Konagai. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController, UICollectionViewDataSource , UICollectionViewDelegate, ARSCNViewDelegate{
    
    let itemsArray: [String] = ["cup", "vase", "boxing", "table"]

    @IBOutlet weak var itemsCollectionView: UICollectionView!
    @IBOutlet weak var sceneView: ARSCNView!
    
    let configuration = ARWorldTrackingConfiguration()
    var selectedItem: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        self.configuration.planeDetection = .horizontal
        self.sceneView.session.run(configuration)
        self.itemsCollectionView.dataSource = self
        self.itemsCollectionView.delegate = self
        self.sceneView.delegate = self
        self.registerGestureRecognizers()
        self.sceneView.autoenablesDefaultLighting = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func registerGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func tapped(sender: UITapGestureRecognizer) {
        let sceneView = sender.view as! ARSCNView
        let tapLocation = sender.location(in: sceneView)
        let hitTest = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        if !hitTest.isEmpty{
            self.addItem(hitTestResult: hitTest.first!)
        } else {
        }
    }
    
    func addItem(hitTestResult: ARHitTestResult) {
        if let selectedItem = self.selectedItem {
            let scene = SCNScene(named: "Assets/\(selectedItem).scn")
            let node = scene?.rootNode.childNode(withName: selectedItem, recursively: false)
            let transform = hitTestResult.worldTransform
            let thirdColumn = transform.columns.3
            node?.position = SCNVector3(thirdColumn.x, thirdColumn.y, thirdColumn.z)
            self.sceneView.scene.rootNode.addChildNode(node!)
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as! itemCell
        cell.itemLabel.text = self.itemsArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        self.selectedItem = itemsArray[indexPath.row]
        cell?.backgroundColor = UIColor(red:0.14, green:0.72, blue:0.89, alpha:1.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor(red:0.89, green:0.31, blue:0.14, alpha:1.0)
    }
}

