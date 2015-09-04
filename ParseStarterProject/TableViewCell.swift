//
//  TableViewCell.swift
//  InstaClone
//
//  Created by Julian Nicholls on 04/09/2015.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    // Swift has silently, helpfullt, and ultimmately confusingly added an Outlet called
    // imageView. I would not have discovered this if I hadn't tried to do the same.

    @IBOutlet weak var uploaded: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var caption: UILabel!
}
