//
//  MemberCollectionViewCell.swift
//  ImpactHub
//
//  Created by Niklas on 17/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class GroupCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var memberCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.clipsToBounds = true
    }

    func setUp(vm: GroupViewModel) {
        nameLabel.text = vm.group.title

        profileImageView.image = UIImage(named: vm.group.photo)
        locationNameLabel.text = vm.group.locationName
        memberCountLabel.text = "\(vm.group.memberCount)"

    }

    
    override func draw(_ rect: CGRect) {
        self.bgView.clipsToBounds = false
        self.bgView.layer.shadowColor = UIColor(hexString: "D5D5D5").cgColor
        self.bgView.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.bgView.layer.shadowOpacity = 0.42
        self.bgView.layer.shadowPath = UIBezierPath(rect: self.bgView.bounds).cgPath
        self.bgView.layer.shadowRadius = 10.0
        
    }
    
    

}
