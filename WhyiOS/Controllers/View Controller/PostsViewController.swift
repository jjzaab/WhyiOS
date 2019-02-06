//
//  PostsViewController.swift
//  WhyiOS
//
//  Created by XMS_JZhan on 2/6/19.
//  Copyright © 2019 XMS_JZhan. All rights reserved.
//

import UIKit

class PostsViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Source of truth
    var posts: [Post] = []
    
    // MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - Helper functions
    func refresh() {
        PostContoller.shared.getPost { (array) in
            if let array = array {
                self.posts = array
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func refreshButtonTapped(_ sender: UIBarButtonItem) {
        refresh()
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Post", message: "Please fill out fields to make a new post", preferredStyle: .alert)
        alert.addTextField { (cohortTextField) in
            cohortTextField.placeholder = "Enter Cohort..."
        }
        alert.addTextField { (nameTextField) in
            nameTextField.placeholder = "Enter Name..."
        }
        alert.addTextField { (reasonTextField) in
            reasonTextField.placeholder = "Enter Reason..."
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (success) in
            guard let cohort = alert.textFields?[0].text, cohort != "", let name = alert.textFields?[1].text, name != "", let reason = alert.textFields?[2].text, reason != "" else { return }
            
            PostContoller.shared.addPost(cohort: cohort, name: name, reason: reason, completion: { (success) in
                
                if success {
                    PostContoller.shared.getPost(completion: { (array) in
                        if let array = array {
                            self.posts = array
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    })
                }
            })
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Extension to conform to tableView delegate and data source
extension PostsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell else { return UITableViewCell() }
        let post = self.posts[indexPath.row]
        cell.cohortLabel.text = post.cohort
        cell.nameLabel.text = post.name
        cell.reasonLabel.text = post.reason
        return cell
    }
}
