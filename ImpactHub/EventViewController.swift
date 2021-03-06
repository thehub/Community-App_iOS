//
//  MemberViewController.swift
//  ImpactHub
//
//  Created by Niklas on 18/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import SafariServices
import PromiseKit


class EventViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate, EventDetailCellDelegate {

    var event: Event!
    
    @IBOutlet weak var companyPhotoImageView: UIImageView!
    @IBOutlet weak var fadeView: UIView!
    @IBOutlet weak var compnayPhotoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var compnayPhotoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabelContainerView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var data = [CellRepresentable]()
    
    var attendingData = [CellRepresentable]()
    
    @IBOutlet weak var connectButtonBottomConsatraint: NSLayoutConstraint?
    var connectButtonBottomConsatraintDefault: CGFloat = 0
    var compnayPhotoHeightConstraintDefault: CGFloat = 0
    @IBOutlet weak var connectButton: UIButton?



    
    var isAttending = false {
        didSet {
            if isAttending {
                self.connectButton?.setTitle("Unattend Event", for: .normal)
            }
            else {
                self.connectButton?.setTitle("Attend Event", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }) { (_) in
            
        }
        
        if self.attendingData.filter ({($0 as? EventViewModel)?.event.id == self.event.id}).first != nil {
            isAttending = true
        }
        else {
            isAttending = false
        }

    }
    
    
    deinit {
        print("\(#file, #function)")
    }
    
    let gradientLayer: CAGradientLayer = CAGradientLayer()
    

    var initialCompanyPhotoScale: CGFloat = 1.8
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.data.removeAll()
        collectionView.reloadData()

        self.title = event.name
        
        if let photoUrl = event.photoUrl {
            self.companyPhotoImageView.kf.setImage(with: photoUrl)
        }

        self.companyPhotoImageView.transform = CGAffineTransform.init(scaleX: initialCompanyPhotoScale, y: initialCompanyPhotoScale)
        
        
        collectionView.register(UINib.init(nibName: TitleViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: TitleViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: EventDetailViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: EventDetailViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: JobViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: JobViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: ProjectViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: ProjectViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: MemberFeedItemViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: MemberFeedItemViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: BigTitleTopViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: BigTitleTopViewModel.cellIdentifier)
        

        // Big Title
        data.append(BigTitleTopViewModel(event: event, cellBackDelegate: self, cellSize: CGSize(width: view.frame.width, height: 250)))

        // Title
        data.append(TitleViewModel(title: "DESCRIPTION", cellSize: CGSize(width: view.frame.width, height: 50)))


        // Event Detail
        data.append(EventDetailViewModel(event: event, cellSize: CGSize(width: view.frame.width, height: 0), eventDetailCellDelegate: self))
    }
    

    var shouldHideStatusBar = true
    
    override var prefersStatusBarHidden: Bool {
        return shouldHideStatusBar
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    var didLayout = false

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        drawFade()
        
        if !didLayout {
            didLayout = true
            connectButtonBottomConsatraintDefault = connectButtonBottomConsatraint?.constant ?? 0
            compnayPhotoHeightConstraintDefault = compnayPhotoHeightConstraint.constant
        }

    }
    
    var shouldDrawFade = true
    
    func drawFade() {
        if !shouldDrawFade {
            return
        }
        if gradientLayer.superlayer == nil {
            gradientLayer.removeFromSuperlayer()
            let startingColorOfGradient = UIColor(hexString: "252424").withAlphaComponent(0.0).cgColor
            let midColor = UIColor(hexString: "181818").withAlphaComponent(0.66).cgColor
            let endingColorOFGradient = UIColor(hexString: "252424").withAlphaComponent(1.0).cgColor
            gradientLayer.frame = self.view.bounds
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y:1.0)
            gradientLayer.locations = [NSNumber.init(value: 0.0), NSNumber.init(value: 0.8), NSNumber.init(value: 1.0)]
            gradientLayer.colors = [startingColorOfGradient, midColor, endingColorOFGradient]
            fadeView.layer.insertSublayer(gradientLayer, at: 0)
        }
        else {
            gradientLayer.frame = self.fadeView.layer.bounds
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        self.navigationController?.navigationBar.shadowImage = nil

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if let vm = data[indexPath.item] as? EventDetailViewModel {
            let cellWidth: CGFloat = self.collectionView.frame.width - 40
            var height = vm.event.description.height(withConstrainedWidth: cellWidth, font:UIFont(name: "GTWalsheim-Light", size: 12.5)!) + 300 + 20 // add extra height for the standard elements, titles, lines, sapcing etc.
            if height < 300 {
                height += 170
            }
            return CGSize(width: view.frame.width, height: height)
        }
        
        if let vm = data[indexPath.item] as? ProjectViewModel {
            let cellWidth: CGFloat = self.collectionView.frame.width
            let width = ((cellWidth - 40) / 1.6)
            let heightToUse = width + 155
            return CGSize(width: view.frame.width, height: heightToUse)
        }
        
        
        var cellSize = data[indexPath.item].cellSize
        if cellSize == .zero {
            let cellHeight = self.view.frame.height
            cellSize = CGSize(width: view.frame.width, height: cellHeight)
        }
        return cellSize
        
    }
    
    var selectJob: Job?
    var selectProject: Project?

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vm = data[indexPath.item] as? JobViewModel {
            self.selectJob = vm.job
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "JobViewController") as! JobViewController
            vc.job = self.selectJob
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if let vm = data[indexPath.item] as? ProjectViewModel {
            self.selectProject = vm.project
            self.performSegue(withIdentifier: "ShowProject", sender: self)
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "ShowProject" {
            if let vc = segue.destination as? ProjectViewController, let selectProject = selectProject {
                vc.project = selectProject
            }
        }
    }
    

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y

        if offset < 0 {
            shouldDrawFade = false
            compnayPhotoHeightConstraint.constant = compnayPhotoHeightConstraintDefault + abs(offset)
        }
        else if offset < 450 {
            compnayPhotoTopConstraint.constant = -(offset * 1.0)
            
            var newScale = initialCompanyPhotoScale - (offset * 0.007)
            if newScale < 1 {
                newScale = 1
            }
            else if newScale > initialCompanyPhotoScale {
                newScale = initialCompanyPhotoScale
            }
            
            self.companyPhotoImageView.transform = CGAffineTransform.init(scaleX: newScale, y: newScale)
            
            self.view.layoutIfNeeded()
        }

        
        
        if scrollView.contentOffset.y > 200 && self.tabBarController?.tabBar.isHidden == true {
            self.tabBarController?.tabBar.isHidden = false
            self.shouldHideStatusBar = false
            self.navigationController?.setNavigationBarHidden(false, animated: true)

            let navBarHeight = self.navigationController?.navigationBar.frame.height ?? 0.0
            connectButtonBottomConsatraint?.constant = connectButtonBottomConsatraintDefault + navBarHeight
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                self.setNeedsStatusBarAppearanceUpdate()
                self.view.layoutIfNeeded()
            }) { (_) in
                
            }
        }
        else if scrollView.contentOffset.y < 200 && self.tabBarController?.tabBar.isHidden == false {
            self.tabBarController?.tabBar.isHidden = true
            self.shouldHideStatusBar = true
            self.navigationController?.setNavigationBarHidden(true, animated: true)

            connectButtonBottomConsatraint?.constant = connectButtonBottomConsatraintDefault
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                self.setNeedsStatusBarAppearanceUpdate()
                self.view.layoutIfNeeded()
            }) { (_) in
                
            }
        }
        
    }
    
    
    var inTransit = false
    
    @IBAction func applyTap(_ sender: Any) {
        if inTransit {
            return
        }
        inTransit = true
        if isAttending {
            isAttending = false
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            firstly {
                APIClient.shared.unattendEvent(contactId: SessionManager.shared.me?.member.contactId ?? "", eventId: self.event.id)
                }.then { result -> Void in
                }.always {
                    self.inTransit = false
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }.catch { error in
                    debugPrint(error.localizedDescription)
                    self.isAttending = true
                    let alert = UIAlertController(title: "Error", message: "Could not unattend event. Please try again.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
            }
        }
        else {
            isAttending = true
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            firstly {
                APIClient.shared.attendEvent(contactId: SessionManager.shared.me?.member.contactId ?? "", eventId: self.event.id)
                }.then { result -> Void in
                }.always {
                    self.inTransit = false
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }.catch { error in
                    debugPrint(error.localizedDescription)
                    self.isAttending = false
                    let alert = UIAlertController(title: "Error", message: "Could not attend event. Please try again.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func wantsToOpenWebsite() {
        self.showWebsite()
    }

    func showWebsite() {
        guard let website = event?.registerURL else { return }
        var websiteToUse = website
        if !websiteToUse.hasPrefix("http") {
            websiteToUse = "http://\(websiteToUse)"
        }
        if let url = URL(string: websiteToUse) {
            let svc = SFSafariViewController(url: url)
            if #available(iOS 10.0, *) {
                svc.preferredBarTintColor = UIColor.imaGrapefruit
            }
            if #available(iOS 11.0, *) {
                svc.dismissButtonStyle = .close
            }
            self.present(svc, animated: true, completion: nil)
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension EventViewController: CellBackDelegate {
    func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension EventViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = data[indexPath.item].cellInstance(collectionView, indexPath: indexPath)
        return cell
    }
}

