//
//  CommentsCellType.swift
//  ForumApp
//
//  Created by Noah Kiefer on 16/08/2018.
//  Copyright © 2018 Noah Kiefer. All rights reserved.
//

import UIKit

class CommentsCellType: UITableViewCell {

    @IBOutlet weak var User: UILabel!
    @IBOutlet weak var Comment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
