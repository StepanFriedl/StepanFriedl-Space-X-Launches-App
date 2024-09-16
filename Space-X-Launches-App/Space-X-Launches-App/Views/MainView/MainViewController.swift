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
        self.title = "All past launches"
        self.view.backgroundColor = .systemBackground
        
        let sortButton = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(showSortingOptions))
        self.navigationItem.rightBarButtonItem = sortButton
        
        setupTableView()
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
        let actionSheet = UIAlertController(title: "Sort Launches", message: "Select a sorting parameter", preferredStyle: .actionSheet)
        
        func addAction(for title: String, sortOption: MainViewModel.SortOption) {
            let isSelected = (viewModel.currentSortOption == sortOption)
            let checkmark = isSelected ? " ✓" : ""
            actionSheet.addAction(UIAlertAction(title: title + checkmark, style: .default, handler: { [weak self] _ in
                self?.viewModel.sortLaunches(by: sortOption)
            }))
        }
        addAction(for: "Sort by Date (Asc)", sortOption: .dateAsc)
        addAction(for: "Sort by Date (Desc)", sortOption: .dateDesc)
        addAction(for: "Sort by Name (Asc)", sortOption: .nameAsc)
        addAction(for: "Sort by Name (Desc)", sortOption: .nameDesc)
        addAction(for: "Sort by Success (Asc)", sortOption: .successAsc)
        addAction(for: "Sort by Success (Desc)", sortOption: .successDesc)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
}
