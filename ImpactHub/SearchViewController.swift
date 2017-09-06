//
//  SearchViewController.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 19/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import PromiseKit
import SalesforceSDKCore


class SearchViewController: ListWithSearchViewController, CreatePostViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor.white), for: .default)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.imaGreyishBrown, NSFontAttributeName: UIFont(name:"GTWalsheim", size:18)!]
        self.navigationController?.navigationBar.barStyle = .default
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // If coming from home short cut
        if showSerachOnOpen {
            showSearch()
            showSerachOnOpen = false
        }
    }
    
    var showSerachOnOpen = false
    
    func showSearch() {
        showSerachOnOpen = false
        self.searchBar?.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.cancelSearching()
    }
    
    var selectedVM: MemberViewModel?
    var memberToSendMessage: Member?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: self)
        if segue.identifier == "ShowMember" {
            if let vc = segue.destination as? MemberViewController, let selectedItem = selectedVM {
                vc.member = selectedItem.member
            }
        }
        else if segue.identifier == "ShowCreatePost" {
            if let navVC = segue.destination as? UINavigationController {
                if let vc = navVC.viewControllers.first as? CreatePostViewController, let contactId = cellWantsToSendContactRequest?.vm?.member.contactId {
                    vc.delegate = self
                    vc.createType = .contactRequest(contactId: contactId)
                }
            }
        }
        else if segue.identifier == "ShowMessageThread" {
            if let vc = segue.destination as? MessagesThreadViewController, let member = self.memberToSendMessage {
                vc.member = member
            }
        }
    }
    
    func didCreatePost(post: Post) {
        
    }
    
    func didCreateComment(comment: Comment) {
        
    }
    
    func didSendContactRequest() {
        self.cellWantsToSendContactRequest?.connectRequestStatus = .outstanding
    }
    
    var cellWantsToSendContactRequest: MemberCollectionViewCell?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    
    
    
    // MARK: Search
    
    override func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // user did type something, check our datasource for text that looks the same
        applySearchAndFilter(searchText: searchText)
    }
    
    override func applySearchAndFilter(searchText: String) {
//        if searchText.characters.count > 0 {
//            // search and reload data source
//            let dataFiltered = self.filterData(dataToFilter: self.dataAll)
//            self.data = self.filterContentForSearchText(dataToFilter: dataFiltered, searchText: searchText)
//            self.collectionView?.reloadData()
//        }
//        else {
//            // if text lenght == 0
//            // we will consider the searchbar is not active
//            let dataFiltered = self.filterData(dataToFilter: self.dataAll)
//            self.data = dataFiltered
//            self.collectionView?.reloadData()
//        }
        
    }
    
    
    override func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.cancelSearching()
        self.collectionView?.reloadData()
    }
    
    override func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    override func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //        self.searchBar!.setShowsCancelButton(true, animated: true)
    }
    
    override func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // this method is being called when search btn in the keyboard tapped
        // we set searchBarActive = NO
        // but no need to reloadCollectionView

        if let searchText = self.searchBar?.text {
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            self.collectionView?.alpha = 0
            firstly {
                ContactRequestManager.shared.refresh()
                }.then { contactRequests -> Void in
                    print("refreshed")
                }.then {
                    APIClient.shared.globalSearch(searchTerm: searchText)
                }.then { members -> Void in
                                    self.dataAll.removeAll()
                                    self.data.removeAll()
                                    self.collectionView.reloadData()
                    //                let cellWidth: CGFloat = self.view.frame.width
                    //                members.forEach({ (member) in
                    //                    // Remove our selves
                    //                    if member.contactId != SessionManager.shared.me?.member.contactId ?? "" {
                    //                        member.contactRequest = ContactRequestManager.shared.getRelevantContactRequestFor(member: member)
                    //                        self.dataAll.append(MemberViewModel(member: member, delegate: self, cellSize: CGSize(width: cellWidth, height: 105)))
                    //                    }
                    //                })

                }.always {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.data = self.filterContentForSearchText(dataToFilter: self.dataAll, searchText: searchText)
                    self.collectionView?.alpha = 0
                    self.collectionView?.reloadData()
                    self.collectionView?.setContentOffset(CGPoint.init(x: 0, y: -20), animated: false)
                    UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                        self.collectionView?.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
                        self.collectionView?.alpha = 1
                    }, completion: { (_) in
                        
                    })
                }.catch { error in
                    debugPrint(error.localizedDescription)
            }
            
        }
        

        self.searchBar!.setShowsCancelButton(false, animated: false)
    }

    
    
    override func filterContentForSearchText(dataToFilter: [CellRepresentable], searchText:String) -> [CellRepresentable] {
        print(searchText)
        return data
    }
}


extension SearchViewController: MemberCollectionViewCellDelegate {
    
    func wantsToCreateNewMessage(member: Member) {
        self.memberToSendMessage = member
        self.performSegue(withIdentifier: "ShowMessageThread", sender: self)
    }
    
    
    func wantsToSendContactRequest(member: Member, cell: MemberCollectionViewCell) {
        self.cellWantsToSendContactRequest = cell
        self.performSegue(withIdentifier: "ShowCreatePost", sender: self)
    }
    
}


extension SearchViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vm = data[indexPath.item] as? MemberViewModel {
            selectedVM = vm
            performSegue(withIdentifier: "ShowMember", sender: self)
        }
    }
}



extension SearchViewController {
    
    override func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = collectionView.indexPathForItem(at: location) else { return nil }
        guard let cell = collectionView.cellForItem(at: indexPath) else { return nil }
        
        var detailVC: UIViewController!
        
        if let vm = data[indexPath.item] as? MemberViewModel {
            selectedVM = vm
            detailVC = storyboard?.instantiateViewController(withIdentifier: "MemberViewController")
            (detailVC as! MemberViewController).member = selectedVM?.member
            
            //        detailVC.preferredContentSize = CGSize(width: 0.0, height: 300)
            previewingContext.sourceRect = cell.frame
            
            return detailVC
        }
        
        return nil
        
    }
}
