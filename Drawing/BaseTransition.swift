//
//  BaseTransition.swift
//  transitionDemo
//
//  Created by Timothy Lee on 2/22/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BaseTransition: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    var duration: TimeInterval = 0.4
    var isPresenting: Bool = true
    var isInteractive: Bool = false
    var transitionContext: UIViewControllerContextTransitioning!
    var interactiveTransition: UIPercentDrivenInteractiveTransition!
    
    // Use for interactive transition
    var percentComplete: CGFloat = 0 {
        didSet {
            interactiveTransition.update(percentComplete)
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if isInteractive {
            interactiveTransition = UIPercentDrivenInteractiveTransition()
            interactiveTransition.completionSpeed = 0.99
        } else {
            interactiveTransition = nil
        }
        return interactiveTransition
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        self.transitionContext = transitionContext
        
        if (isPresenting) {
            containerView.addSubview(toViewController.view)
            presentTransition(containerView: containerView, fromViewController: fromViewController, toViewController: toViewController)
        } else {
            dismissTransition(containerView: containerView, fromViewController: fromViewController, toViewController: toViewController)
        }
    }
    
    func presentTransition(containerView: UIView, fromViewController: UIViewController, toViewController: UIViewController) {
        
    }
    
    func dismissTransition(containerView: UIView, fromViewController: UIViewController, toViewController: UIViewController) {
        
    }
    
    func finish() {
        if isInteractive {
            isInteractive = false
            interactiveTransition.finish()
        } else {
            if isPresenting == false {
                let fromViewController = transitionContext?.viewController(forKey: UITransitionContextViewControllerKey.from)!
                fromViewController?.view.removeFromSuperview()
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    func cancel() {
        if isInteractive {
            isInteractive = false
            interactiveTransition.cancel()
        }
    }
    
}
