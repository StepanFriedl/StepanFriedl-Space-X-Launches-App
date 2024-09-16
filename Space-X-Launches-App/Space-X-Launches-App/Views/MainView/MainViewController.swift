//
//  MainViewController.swift
//  Space-X-Launches-App
//
//  Created by Štěpán Friedl on 15.09.2024.
//

import UIKit
import SwiftUI

class MainViewController: UIViewController {

    // IBoutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    // ViewModel:
    var viewModel: MainViewModel = MainViewModel()
    
    var cellDataSource: [MainLaunchCellViewModel] = []
    var filteredCellDataSource: [MainLaunchCellViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getData()
        configView()
        bindViewmodel()
        
    }
    
    func configView() {
        self.title = "allPastLaunched".localized()
        self.view.backgroundColor = .systemBackground
        
        setupToolbarButtons()
        
        setupTableView()
    }
    
    func setupToolbarButtons() {
        let sortButton = UIBarButtonItem(title: "sort".localized(), style: .plain, target: self, action: #selector(showSortingOptions))
        let globeButton = UIBarButtonItem(image: UIImage(systemName: "globe"), style: .plain, target: self, action: #selector(openLanguageSettings))

        self.navigationItem.rightBarButtonItem = sortButton
        self.navigationItem.leftBarButtonItem = globeButton
        
    }
    
    func bindViewmodel() {
        viewModel.isLoading.bind { [weak self] isLoading in
            guard let self = self, let isLoading = isLoading else {
                return
            }
            DispatchQueue.main.async {
                if isLoading {
                    self.activityIndicator.startAnimating()
                } else {
                    self.activityIndicator.stopAnimating()
                }
            }
        }
        
        viewModel.filteredCellDataSource.bind { [weak self] launches in
            guard let self = self else { return }
            self.reloadTableView()
        }
    }

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
    
    @objc func searchTextChanged(_ textField: UITextField) {
        guard let searchText = textField.text else {
            viewModel.filterLaunches(with: "")
            return
        }
        viewModel.filterLaunches(with: searchText)
    }
    
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
    
}
