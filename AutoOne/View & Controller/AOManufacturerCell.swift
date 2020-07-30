//
//  AOManufacturerCell.swift
//  AutoOne
//
//  Created by Shilpa S on 18/11/19.
//  Copyright © 2019 Shilpa S. All rights reserved.
//

import UIKit

class AOManufacturerCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.separatorInset = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
