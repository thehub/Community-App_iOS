//
//  MemberViewModel.swift
//  ImpactHub
//
//  Created by Niklas on 17/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class ContactPendingViewModel: CellRepresentable {
    
    static var cellIdentifier = "ContactPendingCell"

    var member: Member

    init(member: Member, cellSize: CGSize) {
        self.member = member
        self.cellSize = cellSize
    }
    
    
    func cellInstance(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContactPendingViewModel.cellIdentifier, for: indexPath) as! ContactPendingCell
        cell.setUp(vm: self)
        return cell
    }
    
    var cellSize: CGSize
}
