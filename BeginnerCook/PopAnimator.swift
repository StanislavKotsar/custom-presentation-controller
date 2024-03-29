//
//  PopAnimator.swift
//  BeginnerCook
//
//  Created by Станислав Коцарь on 18/09/2019.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//

import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 1.0
    var presenting = true
    var originFrame = CGRect.zero
    var dismissCompletion: (()->Void)?
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        
        if let toView = transitionContext.view(forKey: .to) {
            containerView.addSubview(toView)
        }
        let herbView = presenting ? transitionContext.view(forKey: .to)! :
            transitionContext.view(forKey: .from)!
        
        let herbViewVC = presenting ? transitionContext.viewController(forKey: .to) as! HerbDetailsViewController :
        transitionContext.viewController(forKey: .from)! as! HerbDetailsViewController
        
        let initialFrame = presenting ? originFrame : herbView.frame
        let finalFrame = presenting ? herbView.frame : originFrame
         
        let xScaleFactor = presenting ?
            initialFrame.width / finalFrame.width :
            finalFrame.width / initialFrame.width
        
        let yScaleFactor = presenting ?
            initialFrame.height / finalFrame.height :
            finalFrame.height / initialFrame.height
        
        containerView.bringSubviewToFront(herbView)

        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor,
                                                    y: yScaleFactor)
        if presenting {
          herbView.transform = scaleTransform
          herbView.center = CGPoint(
            x: initialFrame.midX,
            y: initialFrame.midY)
          herbView.clipsToBounds = true
        }
        
        UIView.animate(withDuration: duration / 2) {
            herbView.layer.cornerRadius = self.presenting ? 0 : 20.0/xScaleFactor
        }
        
        UIView.animate(withDuration: duration, delay:0.0,
          usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0,
          animations: {
            herbView.transform = self.presenting ?
              CGAffineTransform.identity : scaleTransform
            herbView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
            herbViewVC.containerView.alpha = self.presenting ? 1 : 0
          },
          completion: { _ in
            if !self.presenting {
              self.dismissCompletion?()
            }
            transitionContext.completeTransition(true)
          })
    }
    
    
}
