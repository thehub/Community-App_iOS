//
//  ViewController.swift
//  ImpactHub
//
//  Created by Niklas on 17/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import SalesforceSDKCore
import PromiseKit
import UserNotifications



class ViewController: UIViewController {
    
    var observer: NSObjectProtocol?
    
    var sessionManager: SessionManager!

    init(sessionManager: SessionManager = .shared) {
        self.sessionManager = sessionManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.sessionManager = .shared
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMe() // Turn off for auth0
        
        self.observer = NotificationCenter.default.addObserver(forName: NSNotification.Name.onLogin, object: nil, queue: OperationQueue.main) { (_) in
            self.loadMe()
        }
    }
    
    var retries = 1
    
    func loadMe() {
        if let currentUser = SFUserAccountManager.sharedInstance().currentUser, currentUser.isSessionValid {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            print(currentUser.accountIdentity.userId)
            firstly {
                APIClient.shared.getMe(userId: currentUser.accountIdentity.userId)
                }.then { me -> Void in
                    ShortcutManager.shared.updateHomeShortCuts()
                    SessionManager.shared.me = me
                    self.performSegue(withIdentifier: "ShowHome", sender: self)
                }.then {
                    APIClient.shared.getHubs()
                }.then { hubs -> Void in
                    SessionManager.shared.hubs = hubs
                }.always {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }.catch { error in
                    debugPrint(error.localizedDescription)
                    if self.retries > 0 {
                        self.retries -= 1
                        let alert = UIAlertController(title: "Error", message: "Could not log in. Please try again.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                            self.loadMe()
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                    else {
                        SFAuthenticationManager.shared().logoutAllUsers()
                    }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.checkAccessToken() // turn on for auth0
    }
    
    deinit {
        if let observer = self.observer {
            NotificationCenter.default.removeObserver(observer, name: NSNotification.Name.onLogin, object: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    var didShow = false
    
    var controller: UIViewController?
    

    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
}
