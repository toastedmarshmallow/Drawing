//
//  AnimationViewController.swift
//  Drawing
//
//  Created by Go, Ian on 11/15/16.
//  Copyright © 2016 Shannan Hsiao. All rights reserved.
//

import UIKit

class AnimationViewController: UIViewController {

    @IBOutlet weak var frameImageView: UIImageView!
    
    var projectToAnimate: Project!
    var pauseState = true //initialize button as pause
    var animationDuration = 0.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animateProject(project: projectToAnimate, animateFrame: frameImageView, duration: animationDuration)
    }
    
    @IBAction func didPressCancel(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didPressPausePlay(_ sender: UIButton) {
        let player: CALayer = frameImageView.layer
        
        if pauseState == true {
        //if button is in pause state
            pauseLayer(layer: player)
            pauseState = false
            sender.setImage(UIImage(named: "Play.png"), for: UIControlState.normal)
            
        } else {
        //if button is in play state
            resumeLayer(layer: player)
            pauseState = true
            sender.setImage(UIImage(named: "Pause.png"), for: UIControlState.normal)
        }
    }
    
    @IBAction func didPressForward(_ sender: AnyObject) {
        increaseSpeed()
    }
    
    @IBAction func didPressBackward(_ sender: AnyObject) {
        decreaseSpeed()
    }
    
    func animateProject(project: Project, animateFrame: UIImageView, duration: TimeInterval) {
        var animatedImages: [UIImage] = []
        for frame in project.images{
            animatedImages.append(frame)
        }
        
        let animatedImage = UIImage.animatedImage(with: animatedImages, duration: duration)
        animateFrame.image = animatedImage
    }
    
    func pauseLayer(layer: CALayer){
        let pausedTime: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }
    
    func resumeLayer(layer: CALayer){
        let pausedTime: CFTimeInterval = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        
        let timeSincePause: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
    
    func increaseSpeed(){
        animationDuration -= 0.1
        animateProject(project: projectToAnimate, animateFrame: frameImageView, duration: animationDuration)
    }
    
    func decreaseSpeed(){
        animationDuration += 0.1
        animateProject(project: projectToAnimate, animateFrame: frameImageView, duration: animationDuration)
    }

}
