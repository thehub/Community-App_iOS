//
//  MemberDetailTopViewModel.swift
//  ImpactHub
//
//  Created by Niklas on 18/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class MemberDetailTopViewModel: CellRepresentable {
    
    var member: Member
    
    init(member: Member, cellSize: CGSize) {
        self.member = member
        self.cellSize = cellSize
    }
    
    var jobDescriptionLong: String {
        return "Consultant at \(member.job)"
    }
    
    var locationNameLong: String {
        return "Currently working in \(member.locationName)"
    }
    
    
    func cellInstance(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemberDetailTopCell", for: indexPath) as! MemberDetailTopCell
        cell.setup(vm: self)
        return cell
    }
    
    var cellSize: CGSize
}
