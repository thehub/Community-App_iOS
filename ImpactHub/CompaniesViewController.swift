//
//  CompaniesViewController.swift
//  ImpactHub
//
//  Created by Niklas on 17/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class CompaniesViewController: ListWithSearchViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(UINib.init(nibName: "CompanyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CompanyCell")
        
        let item1 = Company(id: "asdsad", name: "Company 1", type: "Charity", photo: "logo", blurb: "Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam.", locationName: "London", website: "www.dn.se", size: "10 - 50")
        let item2 = Company(id: "asdsad", name: "Company 2", type: "Sales", photo: "logo", blurb: "Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam.", locationName: "London", website: "www.dn.se", size: "10 - 50")
        let item3 = Company(id: "asdsad", name: "Compnay 3", type: "Fashion", photo: "logo", blurb: "Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam.", locationName: "London", website: "www.dn.se", size: "10 - 50")
        let item4 = Company(id: "asdsad", name: "Company 4", type: "Design", photo: "logo", blurb: "Lorem ipsum dolor sit amet, habitasse a suspendisse et, nec suscipit imperdiet sed, libero mollis felis egestas vivamus velit, felis velit interdum phasellus luctus, nulla molestie felis ligula diam.", locationName: "London", website: "www.dn.se", size: "10 - 50")

        let cellWidth: CGFloat = self.view.frame.width - 30
        let viewModel1 = CompanyViewModel(company: item1, cellSize: CGSize(width: cellWidth, height: 200))
        let viewModel2 = CompanyViewModel(company: item2, cellSize: CGSize(width: cellWidth, height: 200))
        let viewModel3 = CompanyViewModel(company: item3, cellSize: CGSize(width: cellWidth, height: 200))
        let viewModel4 = CompanyViewModel(company: item4, cellSize: CGSize(width: cellWidth, height: 200))
        
        self.data.append(viewModel1)
        self.data.append(viewModel2)
        self.data.append(viewModel3)
        self.data.append(viewModel4)

    }

    var selectedVM: CompanyViewModel?
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCompany" {
            if let vc = segue.destination as? CompanyViewController, let selectedItem = selectedVM {
                vc.company = selectedItem.company
            }
        }
    }
    
}


extension CompaniesViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vm = data[indexPath.item] as? CompanyViewModel {
            selectedVM = vm
            performSegue(withIdentifier: "ShowCompany", sender: self)
        }
    }
}

extension CompaniesViewController {
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth: CGFloat = self.collectionView.frame.width
        let width = ((cellWidth - 40) / 1.6)
        let heightToUse = width + 155
        return CGSize(width: view.frame.width, height: heightToUse)
        
    }
}
extension CompaniesViewController {
    
    override func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = collectionView.indexPathForItem(at: location) else { return nil }
        guard let cell = collectionView.cellForItem(at: indexPath) else { return nil }
        
        var detailVC: UIViewController!
        
        if let vm = data[indexPath.item] as? CompanyViewModel {
            selectedVM = vm
            detailVC = storyboard?.instantiateViewController(withIdentifier: "CompanyViewController")
            (detailVC as! CompanyViewController).company = selectedVM?.company
            
            //        detailVC.preferredContentSize = CGSize(width: 0.0, height: 300)
            previewingContext.sourceRect = cell.frame
            
            return detailVC
        }
        
        return nil
        
    }
    
    override func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
    
}
