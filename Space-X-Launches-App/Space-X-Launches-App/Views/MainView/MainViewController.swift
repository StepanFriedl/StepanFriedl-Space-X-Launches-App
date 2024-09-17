//
//  MainViewController.swift
//  Space-X-Launches-App
//
//  Created by Štěpán Friedl on 15.09.2024.
//

import UIKit
import SwiftUI

class MainViewController: UIViewController {

    // MARK: - IBoutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var tryAgainButton: UIButton!
    
    // MARK: - Properties:
    var viewModel: MainViewModel = MainViewModel()
    var cellDataSource: [MainLaunchCellViewModel] = []
    var filteredCellDataSource: [MainLaunchCellViewModel] = []
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        viewModel.getData()
        configView()
        bindViewmodel()
    }
    
    // MARK: - UI Configuration
    func configView() {
        self.title = "allPastLaunched".localized()
        self.view.backgroundColor = .systemBackground
        
        setupToolbarButtons()
        setupTableView()
        setupErrorMessageView()
    }
    
    func setupErrorMessageView() {
        let iconImage = UIImage(systemName: "arrow.clockwise")?.withRenderingMode(.alwaysOriginal)
        let scaledImage = iconImage?.resized(to: CGSize(width: 48, height: 48))
        
        var configuration = UIButton.Configuration.plain()
        configuration.image = scaledImage
        tryAgainButton.configuration = configuration
        
        tryAgainButton.setTitle("", for: .normal)
        tryAgainButton.isHidden = true
        
        errorMessageLabel.text = "dataLoadError".localized()
        errorMessageLabel.isHidden = true
    }
    
    func setupToolbarButtons() {
        let sortButton = UIBarButtonItem(title: "sort".localized(), style: .plain, target: self, action: #selector(showSortingOptions))
        let globeButton = UIBarButtonItem(image: UIImage(systemName: "globe"), style: .plain, target: self, action: #selector(openLanguageSettings))
        
        self.navigationItem.rightBarButtonItem = sortButton
        self.navigationItem.leftBarButtonItem = globeButton
        
    }

    // MARK: - Bind ViewModel
    func bindViewmodel() {
        viewModel.isLoading.bind { [weak self] isLoading in
            guard let self = self, let isLoading = isLoading else {
                return
            }
            DispatchQueue.main.async {
                if isLoading {
                    self.activityIndicator.startAnimating()
                    self.tableView.isHidden = true
                    self.errorMessageLabel.isHidden = true
                    self.tryAgainButton.isHidden = true
                } else {
                    self.activityIndicator.stopAnimating()
                }
            }
        }
        
        viewModel.filteredCellDataSource.bind { [weak self] launches in
            guard let self = self, let _ = launches else { return }
            DispatchQueue.main.async {
                self.reloadTableView()
                self.errorMessageLabel.isHidden = true
                self.tryAgainButton.isHidden = true
                self.tableView.isHidden = false
                
                self.viewModel.stopDataFetchTimer()
            }
        }
        
        viewModel.isErrorMessageShown.bind { [weak self] isErrorMessageShown in
            guard let self = self, let isErrorMessageShown = isErrorMessageShown else { return }
            DispatchQueue.main.async {
                if isErrorMessageShown {
                    self.errorMessageLabel.isHidden = false
                    self.tryAgainButton.isHidden = false
                    self.tableView.isHidden = true
                    self.viewModel.isLoading.value = false
                    self.activityIndicator.stopAnimating()
                } else {
                    self.errorMessageLabel.isHidden = true
                    self.tryAgainButton.isHidden = true
                }
            }
        }
    }

    // MARK: - @IBActions
    @IBAction func tryAgainButtonTapped(_ sender: UIButton) {
        viewModel.getData()
        sender.animateClick()
    }

    // MARK: - User Actions
    @objc func showSortingOptions() {
        let actionSheet = UIAlertController(title: "sortLaunches".localized(), message: "selectParameter".localized(), preferredStyle: .actionSheet)
        
        func addAction(for title: String, sortOption: MainViewModel.SortOption) {
            let isSelected = (viewModel.currentSortOption == sortOption)
            let checkmark = isSelected ? " ✓" : ""
            actionSheet.addAction(UIAlertAction(title: title + checkmark, style: .default, handler: { [weak self] _ in
                self?.viewModel.sortLaunches(by: sortOption)
            }))
        }
        addAction(for: "sortByDateAsc".localized(), sortOption: .dateAsc)
        addAction(for: "sortByDateDesc".localized(), sortOption: .dateDesc)
        addAction(for: "sortByNameAsc".localized(), sortOption: .nameAsc)
        addAction(for: "sortByNameDesc".localized(), sortOption: .nameDesc)
        addAction(for: "sortBySuccessAsc".localized(), sortOption: .successAsc)
        addAction(for: "sortBySuccessDesc".localized(), sortOption: .successDesc)
        
        actionSheet.addAction(UIAlertAction(title: "cancel".localized(), style: .cancel, handler: nil))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    @objc func openLanguageSettings() {
        if let appSettingsURL = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(appSettingsURL) {
                UIApplication.shared.open(appSettingsURL, options: [:], completionHandler: nil)
            }
        }
    }

    // MARK: - Navigation
    func openDetail(_ launchID: String) {
        guard let launch = viewModel.retrieveLaunch(with: launchID) else {
            return
        }
        let detailsViewModel = DetailsViewModel(launch: launch)
        let detailsView = DetailViewSwiftUI(viewModel: detailsViewModel)
        let detailsHostingController = UIHostingController(rootView: detailsView)
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(detailsHostingController, animated: true)
        }
    }
    
}
