//
//  CustomViewController.swift
//  DinoComponents
//
//  Created by Fabio Silvestri on 26/09/21.
//

import UIKit

public class CustomViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    public var data:[String]?
    
    lazy var tableview: UITableView = {
        let v = UITableView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.register(CustomQuoteCell.self, forCellReuseIdentifier: "cell")
        return v
    }()
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public func setData(data: [String]) {
        self.data=data
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableview)
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.rowHeight = UITableView.automaticDimension
        self.tableview.estimatedRowHeight = 300
        self.view.backgroundColor = .white
        NSLayoutConstraint.activate([
            self.tableview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableview.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = data?.count {
            return count
        } else {
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomQuoteCell
        guard let rowData = data?[indexPath.row] else { return cell }
        cell.quoteLabel.text = rowData
        return cell
    }

}
