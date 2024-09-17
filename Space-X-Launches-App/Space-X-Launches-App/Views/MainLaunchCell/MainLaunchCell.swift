//
//  MainLaunchCell.swift
//  Space-X-Launches-App
//
//  Created by Štěpán Friedl on 15.09.2024.
//

import UIKit
import SDWebImage

class MainLaunchCell: UITableViewCell {
    
    // MARK: - Static Properties
    public static var identifier: String = "MainLaunchCell"
    
    // MARK: - Static Methods
    public static func register() -> UINib {
        UINib(nibName: "MainLaunchCell", bundle: nil)
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var cellSubtitleLabel: UILabel!
    @IBOutlet weak var cellIconView: UIImageView!
    
    // MARK: - View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCellAppearance()
    }
    
    // MARK: - Configuration
    func configureCellAppearance() {
        cellBackgroundView.addBorder(color: .systemGray2, width: 1)
        cellBackgroundView.round()
        cellImageView.round()
    }
    
    // MARK: - Setup Method
    func setupCell(viewModel: MainLaunchCellViewModel) {
        func configureIcon(isSuccess: Bool?) {
            guard let isSuccess = isSuccess else {
                cellIconView.isHidden = true
                return
            }
            cellIconView.isHidden = false
            cellIconView.image = isSuccess ? UIImage(systemName: "checkmark.circle") : UIImage(systemName: "xmark.circle")
            cellIconView.tintColor = isSuccess ? .green : .red
        }
        
        self.cellTitleLabel.text = viewModel.name
        self.cellSubtitleLabel.text = viewModel.dateFormatted()
        self.cellImageView.sd_setImage(with: viewModel.imageUrl)
        
        configureIcon(isSuccess: viewModel.isSuccess)
    }
    
}
