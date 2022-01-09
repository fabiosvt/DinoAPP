//
//  CustomTableViewController.swift
//  DinoComponents
//
//  Created by Fabio Silvestri on 26/09/21.
//

import UIKit
import DinoComponents

public class CustomTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    public var data = [QuotesModel]()

    @IBOutlet weak public var tableView: UITableView!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
    }

    // MARK: - Table view data source

    public func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        cell.quoteModel = data[indexPath.row]
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pickup = data[indexPath.row] as QuotesModel
        print(indexPath.row)
        let alertView = RFAlertView(frame: self.view.bounds)
        alertView.set(image: pickup.getImage())
        alertView.set(headline: pickup.getAuthor())
        self.view.addSubview(alertView)
    }
}
