//
//  HomeViewController.swift
//  workshop
//
//  Created by Twiscode on 21/07/20.
//  Copyright © 2020 rasyadh. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = Localify.get("home.title")
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .stop,
            target: self,
            action: #selector(signOutTouchUpInside(_:)))
        
        tableView.dataSource = self
        tableView.delegate = self
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

// MARK: - UITableView DataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = "Title \(indexPath.row)"
        cell.detailTextLabel?.text = "Subtitle \(indexPath.row)"
        
        return cell
    }
}

// MARK: - UITableView Delegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
