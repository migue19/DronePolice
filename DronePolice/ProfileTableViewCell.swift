//
//  ProfileTableViewCell.swift
//  DronePolice
//
//  Created by Miguel Mexicano Herrera on 08/12/21.
//  Copyright © 2021 Miguel Mexicano Herrera. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var descriptionLabel: UILabel!
    static let identifier = String(describing: ProfileTableViewCell.self)
    @IBOutlet weak var pictureImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupCell(image: String, description: String) {
        pictureImageView.image = UIImage(named: image)
        descriptionLabel.text = description
    }
}
