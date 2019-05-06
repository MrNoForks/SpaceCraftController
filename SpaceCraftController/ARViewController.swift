//
//  ARViewController.swift
//  NewImageARR&D
//
//  Created by Boppo on 05/04/19.
//  Copyright © 2019 boppo. All rights reserved.
//

import UIKit
import ARKit
class ARViewController: UIViewController,ARSCNViewDelegate
{
    private var sceneView : ARSCNView!
    
    private var virtualObjectNode = ModelLoader()
    
    private var smokeyNode = SCNNode()
    
    var modelName : String?
    
    static let arviewController = ARViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationController?.isNavigationBarHidden = false
        
        sceneView = ARSCNView()
        //sceneView.showsStatistics = true
        view = sceneView
        
        virtualObjectNode.loadModel(modelName: modelName ?? "", positionX: 0, positionY: 0, positionZ: -0.7, modelSize: 0.05, appearanceAnimation: true, withDuration: 2)
        
        // sceneView.debugOptions = [.showWorldOrigin]
        //        let particle = ParticleLoader()
        //        particle.loadParticleSystem()
        
        smokeyNode.addParticleSystem(SCNParticleSystem(named: "smkey.scnp", inDirectory: nil)!)
        smokeyNode.position = SCNVector3(x: -1, y: -1, z: 0)
        
        
        sceneView.scene.rootNode.addChildNode(smokeyNode)
        sceneView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        
        guard let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "ARPhotos", bundle: Bundle.main) else {print("No images avaiable"); return}
        
        configuration.detectionImages = trackedImages
        
        configuration.maximumNumberOfTrackedImages = 0
        
        
        sceneView.session.run(configuration, options: [.resetTracking,.removeExistingAnchors])
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        if let imageAnchor = anchor as? ARImageAnchor{
            
            virtualObjectNode.position = SCNVector3(x: imageAnchor.transform.columns.3.x, y: imageAnchor.transform.columns.3.y, z: imageAnchor.transform.columns.3.z)
            
            smokeyNode.removeFromParentNode()
            
            sceneView.scene.rootNode.addChildNode(virtualObjectNode)
        }
        
        return nil
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        
        guard let pointOfView = renderer.pointOfView else {return}
        // pointOfView.worldFront
        
        
        
        let transform = pointOfView.simdTransform
        let myPosInWorldSpace = simd_make_float4(0,0,-2,1)
        let myPosInCamSpace = simd_mul(transform,myPosInWorldSpace)
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.4
        virtualObjectNode.position = SCNVector3(x: myPosInCamSpace.x, y: myPosInCamSpace.y, z: myPosInCamSpace.z)
        SCNTransaction.commit()
        
        //        let isVisible = renderer.isNode(virtualObjectNode, insideFrustumOf: pointOfView)
        //        if !isVisible{
        //            guard let pointOfView = sceneView.pointOfView else { return}
        //
        //            let transform = pointOfView.simdTransform
        //            let myPosInWorldSpace = simd_make_float4(0,0,-2,1)
        //            let myPosInCamSpace = simd_mul(transform,myPosInWorldSpace)
        //
        //            SCNTransaction.begin()
        //            SCNTransaction.animationDuration = 0.9
        //            virtualObjectNode.position = SCNVector3(x: myPosInCamSpace.x, y: myPosInCamSpace.y, z: myPosInCamSpace.z)
        //            SCNTransaction.commit()
        //        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let pointOfView = sceneView.pointOfView else { return}
        //        print("pointOfView.simdWorldUp \(pointOfView.simdWorldUp)")
        //        print("pointOfView.simdWorldFront \(pointOfView.simdWorldFront)")
        //        print("pointOfView.simdWorldRight \(pointOfView.simdWorldRight)")
        
        //        virtualObjectNode.position = SCNVector3(x: pointOfView.worldFront.x, y: pointOfView.worldFront.y, z: pointOfView.worldFront.z)
        
        let transform = pointOfView.simdTransform
        let myPosInWorldSpace = simd_make_float4(0,0,-2,1)
        let myPosInCamSpace = simd_mul(transform,myPosInWorldSpace)
        
        virtualObjectNode.position = SCNVector3(x: myPosInCamSpace.x, y: myPosInCamSpace.y, z: myPosInCamSpace.z)
        
        
        
        
        //        print("pointOfView.worldFront \(pointOfView.worldFront)")
        //        print("pointOfView.worldUp \(pointOfView.worldUp)")
        //        print("pointOfView.worldRight \(pointOfView.worldRight)")
        //   print("pointOfView.worldPosition\(pointOfView.worldPosition)")
        //        print("pointOfView.position \(pointOfView.position)")
        //        print("pointOfView.camera?.fieldOfView \(pointOfView.camera?.fieldOfView)")
        
        //  print(pointOfView.camera?.projectionTransform)
        //        print("virtualObjectNode.position \(virtualObjectNode.position)")
        //        print("virtualObjectNode.simdWorldPosition \(virtualObjectNode.simdWorldPosition)")
        //        print("virtualObjectNode.worldPosition \(virtualObjectNode.worldPosition)")
        
    }
}
