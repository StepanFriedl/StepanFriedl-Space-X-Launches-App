//
//  MainViewController.swift
//  Space-X-Launches-App
//
//  Created by Štěpán Friedl on 15.09.2024.
//

import UIKit

class MainViewController: UIViewController {

    // IBoutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    // ViewModel:
    var viewModel: MainViewModel = MainViewModel()
    // Cell data source
    var cellDataSource: [MainLaunchCellViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configView()
        bindViewmodel()
    }
    
    func configView() {
        self.title = "All past launches"
        self.view.backgroundColor = .systemBackground
        
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getData()
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
        
        viewModel.cellDataSource.bind { [weak self] launches in
            guard let self = self, let launches = launches else {
                return
            }
            self.cellDataSource = launches
            self.reloadTableView()
        }
    }

}
