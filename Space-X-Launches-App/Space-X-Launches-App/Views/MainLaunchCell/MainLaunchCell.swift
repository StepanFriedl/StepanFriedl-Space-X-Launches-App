//
//  MainLaunchCell.swift
//  Space-X-Launches-App
//
//  Created by Štěpán Friedl on 15.09.2024.
//

import UIKit
import SDWebImage

class MainLaunchCell: UITableViewCell {
    
    public static var identifier: String = "MainLaunchCell"
    
    public static func register() -> UINib {
        UINib(nibName: "MainLaunchCell", bundle: nil)
    }
    
    // IBoutlets
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var cellSubtitleLabel: UILabel!
    @IBOutlet weak var cellIconView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellBackgroundView.addBorder(color: .systemGray2, width: 1)
        cellBackgroundView.round()
        
        cellImageView.round()
    }
    
    func setupCell(viewModel: MainLaunchCellViewModel) {
        self.cellTitleLabel.text = viewModel.name
        self.cellSubtitleLabel.text = viewModel.dateFormatted()
        self.cellImageView.sd_setImage(with: viewModel.imageUrl)
        
        if let isSuccess = viewModel.isSuccess {
            cellIconView.isHidden = false
            cellIconView.image = isSuccess ? UIImage(systemName: "checkmark.circle") : UIImage(systemName: "xmark.circle")
            cellIconView.tintColor = isSuccess ? .green : .red
        } else {
            cellIconView.isHidden = true
        }
    }
}
