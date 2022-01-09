//
//  CustomQuoteCell.swift
//  DinoComponents
//
//  Created by Fabio Silvestri on 26/09/21.
//

import UIKit

class CustomQuoteCell: UITableViewCell {
    
    lazy var baseView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.magenta
        v.layer.cornerRadius = 10
        v.layer.masksToBounds = true
        return v
    }()

    lazy var quoteLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = "some text"
        v.font = UIFont(name: "Avenir Next", size: 24)
        v.numberOfLines = 0
        return v
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupView() {
        self.addSubview(baseView)
        self.baseView.addSubview(quoteLabel)
        NSLayoutConstraint.activate([
            self.baseView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            self.baseView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            self.baseView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            self.baseView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            self.quoteLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            self.quoteLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            self.quoteLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.quoteLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
        ])
    }

}
