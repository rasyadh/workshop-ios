//
//  HomeViewController.swift
//  workshop
//
//  Created by Twiscode on 21/07/20.
//  Copyright © 2020 rasyadh. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = Localify.get("home.title")
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .stop,
            target: self,
            action: #selector(signOutTouchUpInside(_:)))
    }
    
    // MARK: - Selector
    @objc func signOutTouchUpInside(_ sender: UIBarButtonItem) {
        Alertify.displayConfirmationDialog(
            title: Localify.get("home.alert.signout.title"),
            message: Localify.get("home.alert.signout.message"),
            confirmTitle: Localify.get("alertify.ok"),
            sender: self,
            isDestructive: true) { [weak self] in
                guard let self = self else { return }
                Storify.shared.logoutUser()
                self.managerViewController?.showLoginScreen(isFromLogout: true)
        }
    }
}
