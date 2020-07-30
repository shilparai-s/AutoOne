//
//  AOBaseViewController.swift
//  AutoOne
//
//  Created by Shilpa S on 20/11/19.
//  Copyright © 2019 Shilpa S. All rights reserved.
//

import UIKit

class AOBaseViewController: UIViewController {

    var activityIndicatorView : AOActivityIndicatorView?
    
    
    
    public func showActivityIndicator() {
        if self.activityIndicatorView != nil {
            self.hideActivityIndicator()
        }
        
        self.setupActivityIndicator()
        
        DispatchQueue.main.async {
             self.startAnimating()
         }
    }
    
    public func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.stopAnimating()
        }
    }

    
     private func setupActivityIndicator() {
        if self.activityIndicatorView == nil {
            self.activityIndicatorView = AOActivityIndicatorView(frame: CGRect(x: 0.0, y: 0.0,width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height))
        }
    }
    
    private func startAnimating() {
        guard let activityIndicatorView = self.activityIndicatorView else { return }
        UIApplication.shared.keyWindow?.addSubview(activityIndicatorView)
        
        if !UIApplication.shared.isIgnoringInteractionEvents {
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
    }
    
    private func stopAnimating() {
        self.activityIndicatorView?.removeFromSuperview()
        self.activityIndicatorView = nil
        
        if UIApplication.shared.isIgnoringInteractionEvents {
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    

}
