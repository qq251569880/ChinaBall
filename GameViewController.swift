//
//  GameViewController.swift
//  ChinaBall
//
//  Created by 张宏台 on 15/6/29.
//  Copyright (c) 2015年 张宏台. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    override func viewDidAppear(animated: Bool) {
        //  Geometry
        var  geometryNode:  SCNNode  =  SCNNode()
        //  Gestures
        var  currentAngle:  Float  =  0.0
        // MARK: Scene
        func sceneSetup() {
            // 实例化一个空的SCNScene类，接下来要用它做更多的事
            let scene = SCNScene()
            let ambientLightNode = SCNNode()
            ambientLightNode.light = SCNLight()
            ambientLightNode.light!.type = SCNLightTypeAmbient
            ambientLightNode.light!.color = UIColor(white: 0.67, alpha: 1.0)
            scene.rootNode.addChildNode(ambientLightNode)
            
            let  omniLightNode  =  SCNNode()
            omniLightNode.light  =  SCNLight()
            omniLightNode.light!.type  =  SCNLightTypeOmni
            omniLightNode.light!.color  =  UIColor(white:  0.75,  alpha:  1.0)
            omniLightNode.position  =  SCNVector3Make(0,  50,  50)
            scene.rootNode.addChildNode(omniLightNode)
            
            let  cameraNode  =  SCNNode()
            cameraNode.camera  =  SCNCamera()
            cameraNode.position  =  SCNVector3Make(0,  0,  25)
            scene.rootNode.addChildNode(cameraNode)
            
            
            // 定义一个SCNBox类的几何实例然后创建盒子，并将其作为根节点的子节点，根节点就是scene
            let boxGeometry = SCNBox(width: 10.0, height: 10.0, length: 10.0, chamferRadius: 1.0)
            let boxNode =  SCNNode(geometry: boxGeometry)
            scene.rootNode.addChildNode(boxNode)
            // 将场景放进sceneView中显示
            // retrieve the SCNView
            let scnView = self.view as SCNView
            geometryNode = boxNode
/*            let panRecognizer = UIPanGestureRecognizer(target: self, action: "panGesture:")
            scnView.addGestureRecognizer(panRecognizer)
  */
            // add a tap gesture recognizer
            let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
            let gestureRecognizers = NSMutableArray()
            gestureRecognizers.addObject(tapGesture)
            if let existingGestureRecognizers = scnView.gestureRecognizers {
                gestureRecognizers.addObjectsFromArray(existingGestureRecognizers)
            }
            scnView.gestureRecognizers = gestureRecognizers
           
            scnView.scene = scene
            //scnView.autoenablesDefaultLighting = true
            //scnView.allowsCameraControl = true
        }
        func  panGesture(sender:  UIPanGestureRecognizer)  {
                let  translation  =  sender.translationInView(sender.view!)
                var  newAngle  =  (Float)(translation.x)*(Float)(M_PI)/180.0
                newAngle += currentAngle
                
                geometryNode.transform  =  SCNMatrix4MakeRotation(newAngle, 0,1, 0)
                
                if(sender.state  ==  UIGestureRecognizerState.Ended)  {
                      currentAngle  =  newAngle
            }
        }
        sceneSetup();
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        /*
        // create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.dae")!
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLightTypeOmni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLightTypeAmbient
        ambientLightNode.light!.color = UIColor.darkGrayColor()
        scene.rootNode.addChildNode(ambientLightNode)
        
        // retrieve the ship node
        let ship = scene.rootNode.childNodeWithName("ship", recursively: true)!
        
        // animate the 3d object
        ship.runAction(SCNAction.repeatActionForever(SCNAction.rotateByX(0, y: 2, z: 0, duration: 1)))
        
        // retrieve the SCNView
        let scnView = self.view as SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.blackColor()
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
        let gestureRecognizers = NSMutableArray()
        gestureRecognizers.addObject(tapGesture)
        if let existingGestureRecognizers = scnView.gestureRecognizers {
            gestureRecognizers.addObjectsFromArray(existingGestureRecognizers)
        }
        scnView.gestureRecognizers = gestureRecognizers*/
    }
 
    func handleTap(gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.locationInView(scnView)
        if let hitResults = scnView.hitTest(p, options: nil) {
            // check that we clicked on at least one object
            if hitResults.count > 0 {
                // retrieved the first clicked object
                let result: AnyObject! = hitResults[0]
                
                // get its material
                let material = result.node!.geometry!.firstMaterial!
                
                // highlight it
                SCNTransaction.begin()
                SCNTransaction.setAnimationDuration(0.5)
                
                // on completion - unhighlight
                SCNTransaction.setCompletionBlock {
                    SCNTransaction.begin()
                    SCNTransaction.setAnimationDuration(0.5)
                    
                    material.emission.contents = UIColor.blackColor()
                    
                    SCNTransaction.commit()
                }
                
                material.emission.contents = UIColor.redColor()
                
                SCNTransaction.commit()
            }
        }
    }
    /*
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
