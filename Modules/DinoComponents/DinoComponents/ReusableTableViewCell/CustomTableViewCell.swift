//
//  CustomTableViewCell.swift
//  DinoComponents
//
//  Created by Fabio Silvestri on 26/09/21.
//

import UIKit

public class CustomTableViewCell: UITableViewCell {

    public var quoteModel: QuotesModel? {
        didSet {
            if let q = quoteModel {
                backgroundImage.image = q.image
                quoteLabel.text = q.quote
                authoLabel.text = q.author
            }
        }
    }
    
    lazy var backgroundImage: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFit
        v.alpha = 0.3
        return v
    }()
    
    lazy var quoteLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = "Some text"
        v.font = v.font.withSize(24)
        v.numberOfLines = 0
        return v
    }()
    
    lazy var authoLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = "someone"
        v.font = v.font.withSize(16)
        v.numberOfLines = 0
        return v
    }()
    
    public func setupView() {
        self.addSubview(backgroundImage)
        self.addSubview(quoteLabel)
        self.addSubview(authoLabel)
        NSLayoutConstraint.activate([
            self.backgroundImage.widthAnchor.constraint(equalToConstant: 100),
            self.backgroundImage.heightAnchor.constraint(equalToConstant: 100),
            self.backgroundImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            self.backgroundImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            self.quoteLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.quoteLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            self.quoteLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            self.quoteLabel.bottomAnchor.constraint(equalTo: self.authoLabel.topAnchor, constant: -20),
            self.authoLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            self.authoLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
