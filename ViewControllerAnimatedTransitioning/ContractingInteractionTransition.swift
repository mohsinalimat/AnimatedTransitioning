//
//  InteractionTransition.swift
//  ViewControllerAnimatedTransitioning
//
//  Created by Dave on 2017. 2. 21..
//  Copyright © 2017년 Yainoma. All rights reserved.
//

import UIKit

class ContractingInteractionTransition: NSObject {
    
    var viewController: DetailViewController! {
        didSet {
            viewController.view.addGestureRecognizer(panGestureRecognizer)
            originImageCenter = viewController.imageView.center
        }
    }
    
    var originImageCenter: CGPoint!
    
    var animatedTransition: UIViewControllerAnimatedTransitioning?
    
    private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        return UIPanGestureRecognizer(target: self, action: #selector(handlePanGestureRecognizer(_:)))
    }()
    
    fileprivate var transitionContext: UIViewControllerContextTransitioning!
    
    // MARK: - Private

    private func endedImageView(with gestureRecognizer: UIPanGestureRecognizer) {
        guard let recognizerView = gestureRecognizer.view else { return }
        
        let velocity = gestureRecognizer.velocity(in: recognizerView)
        let returnToCenterVelocityAnimationRatio = 0.00007
        let animationDuration = (Double(abs(velocity.y)) * returnToCenterVelocityAnimationRatio) + 0.2
        print("animationDuration: \(animationDuration), velocityY: \(velocity.y)")
        
        let panDismissDistanceRatio = 100.0 / recognizerView.bounds.height
        let dismissDistance = Double(panDismissDistanceRatio) * Double(recognizerView.bounds.height)
        let verticalMoveY = viewController.imageView.center.y - originImageCenter.y
        let isDismissing = Double(abs(verticalMoveY)) > dismissDistance
        
        if isDismissing {
            self.animatedTransition?.animateTransition(using: self.transitionContext)
            return
        }
        
        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut, animations: {
            self.viewController.imageView.center = self.originImageCenter
            self.viewController.view.backgroundColor = self.viewController.view.backgroundColor?.withAlphaComponent(1.0)
        }) { (finished) in
            self.transitionContext?.cancelInteractiveTransition()
        }
    }
    
    private func backgroundAlphaForPanningWithVerticalDelta(_ delta: CGFloat) -> CGFloat {
        let startingAlpha: CGFloat = 1.0
        let finalAlpha: CGFloat = 0.1
        let totalAvailableAlpha = startingAlpha - finalAlpha
        
        let maximumDelta = CGFloat(viewController.view.bounds.height / 2.0)
        let deltaAsPercentageOfMaximum = min(abs(delta) / maximumDelta, 1.0)
        return startingAlpha - (deltaAsPercentageOfMaximum * totalAvailableAlpha)
    }
    
    // MARK: - Actions
    
    func handlePanGestureRecognizer(_ gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            (viewController.navigationController as? TransitioningNavigationController)?.interactiveDismissal = true
            viewController.dismiss(animated: true, completion: nil)
        case .ended:
            endedImageView(with: gestureRecognizer)
            (viewController.navigationController as? TransitioningNavigationController)?.interactiveDismissal = false
        default:
            let movedPoint = gestureRecognizer.translation(in: viewController.view)
            let newCenterPoint = CGPoint(x: originImageCenter.x, y: originImageCenter.y + movedPoint.y)
            viewController.imageView.center = newCenterPoint
            
            let backgroundAlpha = backgroundAlphaForPanningWithVerticalDelta(newCenterPoint.y - originImageCenter.y)
            print("backgroundAlpha: \(backgroundAlpha)")
            viewController.view.backgroundColor = viewController.view.backgroundColor?.withAlphaComponent(backgroundAlpha)
        }
    }
    
}

extension ContractingInteractionTransition: UIViewControllerInteractiveTransitioning {
    
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
    }
}
