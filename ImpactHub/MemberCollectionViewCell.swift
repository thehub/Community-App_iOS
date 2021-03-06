//
//  MemberCollectionViewCell.swift
//  ImpactHub
//
//  Created by Niklas on 17/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

protocol MemberCollectionViewCellDelegate: class {
    func wantsToCreateNewMessage(member: Member)
    func wantsToSendContactRequest(member: Member, cell: MemberCollectionViewCell)
}

class MemberCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var openMessageButton: UIButton!
    @IBOutlet weak var locationPin: UIImageView!
    
    weak var memberCollectionViewCellDelegate: MemberCollectionViewCellDelegate?

    var connectRequestStatus = DMRequest.Satus.notRequested {
        didSet {
            updateConnectButton()
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var connectionImageView: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var locationNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        profileImageView.clipsToBounds = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
    }

    
    @IBAction func openMessageTap(_ sender: Any) {
        guard let member = vm?.member else { return }
        
        if member.contactRequest?.status == .notRequested || member.contactRequest == nil {
            memberCollectionViewCellDelegate?.wantsToSendContactRequest(member: member, cell: self)
        }
        else if member.contactRequest?.status == .approved {
            memberCollectionViewCellDelegate?.wantsToCreateNewMessage(member: member)
        }

    }
    
    var vm:MemberViewModel?
    
    func setUp(vm: MemberViewModel) {
        self.vm = vm
        self.memberCollectionViewCellDelegate = vm.delegate
        nameLabel.text = vm.member.name
        jobLabel.text = vm.member.job
        if let photoUrl = vm.member.photoUrl {
//            print(photoUrl)
            profileImageView.kf.setImage(with: photoUrl, placeholder: nil, options: [.transition(.fade(0.2))], progressBlock: nil, completionHandler: { (image, error, cacheType, url) in
//                if let error = error {
//                    print(error.localizedDescription)
//                }
            })
        }
        locationNameLabel.text = vm.member.impactHubCities?.replacingOccurrences(of: ";", with: ", ")
        if locationNameLabel.text == nil {
            locationPin.isHidden = true
        }
        else {
            locationPin.isHidden = false
        }

        self.connectRequestStatus = vm.member.contactRequest?.status ?? .notRequested
        
    }

    func updateConnectButton() {
        if connectRequestStatus == .outstanding || connectRequestStatus == .approveDecline {
            connectionImageView.image = UIImage(named: "waitingSmall")
            connectionImageView.isHidden = false
            openMessageButton.isHidden = true
        }
        else if connectRequestStatus == .declined {
            connectionImageView.isHidden = true
            openMessageButton.isHidden = true
        }
        else {
            connectionImageView.image = UIImage(named: "memberConnected")
            connectionImageView.isHidden = false
            openMessageButton.isHidden = false
        }
        
        // Do not show if ourselves...
        if vm?.member.contactId == SessionManager.shared.me?.member.contactId {
            openMessageButton.isHidden = true
            connectionImageView.isHidden = true
        }

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
