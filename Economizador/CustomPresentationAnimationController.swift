//
//  Created by Pete Callaway on 26/06/2014.
//  Copyright (c) 2014 Dative Studios. All rights reserved.
//

import UIKit


class CustomPresentationAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    let isPresenting :Bool
    let duration :TimeInterval = 0.5

    init(isPresenting: Bool) {
        self.isPresenting = isPresenting

        super.init()
    }


    // ---- UIViewControllerAnimatedTransitioning methods

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning)  {
        if isPresenting {
            animatePresentationWithTransitionContext(transitionContext)
        }
        else {
            animateDismissalWithTransitionContext(transitionContext)
        }
    }


    // ---- Helper methods

    func animatePresentationWithTransitionContext(_ transitionContext: UIViewControllerContextTransitioning) {

        guard
            let presentedController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
			let presentedControllerView = transitionContext.view(forKey: UITransitionContextViewKey.to),
            let containerView: UIView? = transitionContext.containerView
        else {
            return
        }

        // Position the presented view off the top of the container view
        presentedControllerView.frame = transitionContext.finalFrame(for: presentedController)
        presentedControllerView.center.y -= containerView!.bounds.size.height
        
        //Redondear puntas
        presentedControllerView.layer.borderWidth = 2
        presentedControllerView.layer.masksToBounds = false
        presentedControllerView.layer.borderColor = UIColor.white.cgColor
        presentedControllerView.layer.cornerRadius = presentedControllerView.frame.size.height/CGFloat(16)
        presentedControllerView.clipsToBounds = true
        
        

        containerView?.addSubview(presentedControllerView)

        // Animate the presented view to it's final position
        UIView.animate(withDuration: self.duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .allowUserInteraction, animations: {
            presentedControllerView.center.y += containerView!.bounds.size.height
        }, completion: {(completed: Bool) -> Void in
            transitionContext.completeTransition(completed)
        })
    }

    func animateDismissalWithTransitionContext(_ transitionContext: UIViewControllerContextTransitioning) {

        guard
            let presentedControllerView = transitionContext.view(forKey: UITransitionContextViewKey.from),
            let containerView: UIView? = transitionContext.containerView
        else {
            return
        }

        // Animate the presented view off the bottom of the view
        UIView.animate(withDuration: self.duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .allowUserInteraction, animations: {
            presentedControllerView.center.y += containerView!.bounds.size.height
        }, completion: {(completed: Bool) -> Void in
                transitionContext.completeTransition(completed)
        })
    }
}
