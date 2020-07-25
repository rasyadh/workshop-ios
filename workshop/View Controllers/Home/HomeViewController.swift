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
    
    // MARK: - Variables
    var movies = [Movie]() {
        didSet {
            // set computed property to reload table view
            // each time the data get updated
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = Localify.get("home.title")
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .stop,
            target: self,
            action: #selector(signOutTouchUpInside(_:)))
        
        // register xib file for cell table view
        tableView.register(
            UINib(nibName: "HeaderMovieTableViewCell", bundle: nil),
            forCellReuseIdentifier: "HeaderMovieTableCell")
        tableView.register(
            UINib(nibName: "MovieTableViewCell", bundle: nil),
            forCellReuseIdentifier: "MovieTableCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 16.0, left: 0.0, bottom: 16.0, right: 0.0)
        
        // populate dummy data
        initData()
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
    
    // MARK: - Functions
    fileprivate func initData() {
        movies = [
            Movie(
                id: 1,
                title: "Spider-Man: Far from Home",
                overview: "Peter Parker and his friends go on a summer trip to Europe. However, they will hardly be able to rest - Peter will have to agree to help Nick Fury uncover the mystery of creatures that cause natural disasters and destruction throughout the continent.",
                posterPath: "https://image.tmdb.org/t/p/w600_and_h900_bestv2/4q2NNj4S5dG2RLF9CpXsej7yXl.jpg",
                releaseDate: "2019-07-02".toDate(format: "yyyy-MM-dd")),
            Movie(
                id: 2,
                title: "Your Name.",
                overview: "High schoolers Mitsuha and Taki are complete strangers living separate lives. But one night, they suddenly switch places. Mitsuha wakes up in Taki’s body, and he in hers. This bizarre occurrence continues to happen randomly, and the two must adjust their lives around each other.",
                posterPath: "https://image.tmdb.org/t/p/w600_and_h900_bestv2/q719jXXEzOoYaps6babgKnONONX.jpg",
                releaseDate: "2016-08-26".toDate(format: "yyyy-MM-dd")),
            Movie(
                id: 3,
                title: "Joker",
                overview: "During the 1980s, a failed stand-up comedian is driven insane and turns to a life of crime and chaos in Gotham City while becoming an infamous psychopathic crime figure.",
                posterPath: "https://image.tmdb.org/t/p/w600_and_h900_bestv2/udDclJoHjfjb8Ekgsd4FDteOkCU.jpg",
                releaseDate: "2019-01-02".toDate(format: "yyyy-MM-dd")),
            Movie(
                id: 4,
                title: "Interstellar",
                overview: "The adventures of a group of explorers who make use of a newly discovered wormhole to surpass the limitations on human space travel and conquer the vast distances involved in an interstellar voyage.",
                posterPath: "https://image.tmdb.org/t/p/w600_and_h900_bestv2/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg",
                releaseDate: "2014-11-06".toDate(format: "yyyy-MM-dd"))
        ]
    }
}

// MARK: - UITableView DataSource
extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return movies.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 1:
            return createMovieCell(indexPath)
        default:
            return createHeaderMovieCell(indexPath)
        }
    }
    
    func createHeaderMovieCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "HeaderMovieTableCell", for: indexPath) as! HeaderMovieTableViewCell
        
        cell.titleHeader = "Popular"
        cell.selectionStyle = .none
        
        return cell
    }
    
    func createMovieCell(_ indexPath: IndexPath) -> UITableViewCell {
        // set table view reusable cell
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "MovieTableCell", for: indexPath) as! MovieTableViewCell
        
        cell.movie = movies[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
}

// MARK: - UITableView Delegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
