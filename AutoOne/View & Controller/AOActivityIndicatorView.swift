//
//  AOActivityIndicatorView.swift
//  AutoOne
//
//  Created by Shilpa S on 20/11/19.
//  Copyright © 2019 Shilpa S. All rights reserved.
//

import UIKit

class AOActivityIndicatorView: UIView {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initSubviews()
    }
    
    fileprivate func initSubviews() {
        let nib = UINib(nibName: "AOActivityIndicatorView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        self.contentView.frame = CGRect(x: 0.0,y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.frame = self.contentView.frame
        self.addSubview(self.contentView)
        self.layoutIfNeeded()
    }

}
