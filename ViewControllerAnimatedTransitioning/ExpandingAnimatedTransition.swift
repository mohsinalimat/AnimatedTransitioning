//
//  ExpandingAnimatedTransition.swift
//  ViewControllerAnimatedTransitioning
//
//  Created by Dave on 2017. 2. 16..
//  Copyright © 2017년 Yainoma. All rights reserved.
//

import UIKit
import AVFoundation

class ExpandingAnimatedTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var cell: CollectionViewCell?
    
    private let duration = 0.37
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let cell = self.cell,
            let toNavi = transitionContext.viewController(forKey: .to) as? TransitioningNavigationController,
            let toController = toNavi.topViewController as? DetailViewController,
            let fromController = (transitionContext.viewController(forKey: .from) as? UINavigationController)?.topViewController as? ViewController else { return }
        
        let expandingView = UIImageView(image: cell.imageView.image)
        expandingView.contentMode = toController.imageView.contentMode
        expandingView.clipsToBounds = true
        expandingView.frame = expandingViewRect(from: fromController)
        
        transitionContext.containerView.addSubview(expandingView)
        transitionContext.containerView.addSubview(toNavi.view)
        
        toNavi.view.alpha = 0.0
        cell.alpha = 0.0
        
        UIView.animate(withDuration: duration, animations: {
            expandingView.frame = self.expandingViewRect(to: toController)
        }) { (finished) in
            expandingView.removeFromSuperview()
            
            toNavi.view.alpha = 1.0
            cell.alpha = 1.0
            
            transitionContext.completeTransition(finished)
        }
    }
    
    private func expandingViewRect(from viewController: ViewController) -> CGRect {
        let origin = CGPoint(x: cell!.frame.origin.x,
                             y: cell!.frame.origin.y - viewController.collectionView!.contentOffset.y)
        return CGRect(origin: origin, size: cell!.imageView.frame.size)
    }
    
    private func expandingViewRect(to viewController: DetailViewController) -> CGRect {
        let navigationHeight = UIApplication.shared.statusBarFrame.size.height + (viewController.navigationController?.navigationBar.frame.size.height ?? CGFloat(0.0))
        return AVMakeRect(aspectRatio: cell!.imageView.image!.size, insideRect: CGRect(
            x: 0,
            y: navigationHeight,
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.height - navigationHeight))
    }
}
