//
//  MemberViewModel.swift
//  ImpactHub
//
//  Created by Niklas on 17/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class ContactViewModel: CellRepresentable {
    
    static var cellIdentifier = "ContactCell"

    var member: Member
    
    init(member: Member, cellSize: CGSize) {
        self.member = member
        self.cellSize = cellSize
    }
    
    
    func cellInstance(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContactViewModel.cellIdentifier, for: indexPath) as! ContactCell
        cell.setUp(vm: self)
        return cell
    }
    
    var cellSize: CGSize
}
