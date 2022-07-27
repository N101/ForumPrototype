//
//  CellType.swift
//  ForumApp
//
//  Created by Noah Kiefer on 25/06/2018.
//  Copyright © 2018 Noah Kiefer. All rights reserved.
//

import UIKit

class CellType: UITableViewCell {

    @IBOutlet weak var CellLayout: UIView!
    @IBOutlet weak var Header: UILabel!
    @IBOutlet weak var Subtext: UILabel!
    @IBOutlet weak var Pic: UIImageView!
    @IBOutlet weak var user_name: UILabel!
    @IBOutlet weak var post_id: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
