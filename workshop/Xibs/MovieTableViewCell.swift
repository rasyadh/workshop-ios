//
//  MovieTableViewCell.swift
//  workshop
//
//  Created by Twiscode on 25/07/20.
//  Copyright © 2020 rasyadh. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageContent: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    // MARK: - Variable
    var movie: Movie! {
        didSet {
            guard let movie = movie else { return }
            
            imageContent.kf.indicatorType = .activity
            imageContent.kf.setImage(with: URL(string: movie.posterPath))
            titleLabel.text = movie.title
            dateLabel.text = movie.releaseDate.toString(format: "dd MMMM yyyy")
            overviewLabel.text = movie.overview
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.setBorderViewColor(UIColor(hex: "#DFDFE7"))
        containerView.setRoundedCorner(cornerRadius: 14.0)
        imageContent.setRoundedCorner(cornerRadius: 14.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageContent.image = nil
        titleLabel.text = ""
        dateLabel.text = ""
        overviewLabel.text = ""
    }
}
