//
//  TitleCell.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 20/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class TitleCell: UICollectionViewCell {
    
    @IBOutlet weak var titleTextLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUp(vm: TitleViewModel) {
        titleTextLabel.text = vm.title
        
    }

    
}
