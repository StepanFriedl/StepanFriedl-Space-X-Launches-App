//
//  MainViewModel.swift
//  Space-X-Launches-App
//
//  Created by Štěpán Friedl on 15.09.2024.
//

import Foundation

class MainViewModel {
    
    // MARK: - Enums
    enum SortOption: String {
        case dateAsc
        case dateDesc
        case nameAsc
        case nameDesc
        case successAsc
        case successDesc
    }
    
    // MARK: - Observables
    var isLoading: Observable<Bool> = Observable(false)
    var isErrorMessageShown: Observable<Bool> = Observable(false)
    var cellDataSource: Observable<[MainLaunchCellViewModel]> = Observable(nil)
    var filteredCellDataSource: Observable<[MainLaunchCellViewModel]> = Observable(nil)
    
    // MARK: - Variables
    var dataSource: PastLaunches?
    var dataFetchTimer: Timer?
    
    // MARK: - Search and Sort State
    private var currentSearchQuery: String = ""
    lazy var currentSortOption: SortOption = {
        return loadSortOptionFromUserDefaults() ?? .dateAsc
    }() {
        didSet {
            self.saveSortOptionToUserDefaults(currentSortOption)
        }
    }
    
    // MARK: - Data Fetching
    func getData() {
        if isLoading.value ?? true {
            return
        }
        isLoading.value = true
        isErrorMessageShown.value = false
        startDataFetchTimer()
        let requestUrlString = NetworkConstant.serverAddress + NetworkConstant.pastLaunches
        APICaller.fetchData(from: requestUrlString) { [weak self] (result: Result<PastLaunches, NetworkError>) in
            self?.isLoading.value = false
            switch result {
            case .success(let data):
                self?.dataSource = data
                self?.mapCellData()
            case .failure:
                self?.isErrorMessageShown.value = true
            }
        }
    }

    func mapCellData() {
        let launches = self.dataSource?.compactMap { MainLaunchCellViewModel(launch: $0) }
        self.cellDataSource.value = launches
        self.applyFiltersAndSorting()
    }
    
    // MARK: - Sorting and Filtering
    func filterLaunches(with query: String) {
        currentSearchQuery = query
        guard let launches = cellDataSource.value else { return }
        
        if query.isEmpty {
            self.filteredCellDataSource.value = launches
        } else {
            self.filteredCellDataSource.value = launches.filter {
                $0.name.lowercased().contains(query.lowercased())
            }
        }
        
        sortLaunches(by: currentSortOption)
    }

    func sortLaunches(by option: SortOption) {
        currentSortOption = option
        guard let launches = filteredCellDataSource.value else { return }
        
        switch option {
        case .dateAsc:
            self.filteredCellDataSource.value = launches.sorted { $0.date ?? Date() < $1.date ?? Date() }
        case .dateDesc:
            self.filteredCellDataSource.value = launches.sorted { $0.date ?? Date() > $1.date ?? Date() }
        case .nameAsc:
            self.filteredCellDataSource.value = launches.sorted { $0.name < $1.name }
        case .nameDesc:
            self.filteredCellDataSource.value = launches.sorted { $0.name > $1.name }
        case .successAsc:
            self.filteredCellDataSource.value = launches.sorted(by: {
                ($0.isSuccess ?? false) == false && ($1.isSuccess ?? false) == true
            })
        case .successDesc:
            self.filteredCellDataSource.value = launches.sorted(by: {
                ($0.isSuccess ?? false) == true && ($1.isSuccess ?? false) == false
            })
        }
    }

    private func applyFiltersAndSorting() {
        filterLaunches(with: currentSearchQuery)
    }
    
    // MARK: - Timer Management
    func startDataFetchTimer() {
        guard dataFetchTimer == nil else { return }
        DispatchQueue.main.async {
            self.dataFetchTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.handleDataFetchTimeout), userInfo: nil, repeats: false)
        }
    }

    func stopDataFetchTimer() {
        DispatchQueue.main.async {
            self.dataFetchTimer?.invalidate()
            self.dataFetchTimer = nil
        }
    }
    
    @objc func handleDataFetchTimeout() {
        DispatchQueue.main.async {
            self.stopDataFetchTimer()
            self.isErrorMessageShown.value = true
        }
    }
    
    // MARK: - Launch Retrieval
    func retrieveLaunch(with id: String) -> Launch? {
        dataSource?.first(where: { $0.id == id })
    }
    
    func cellViewModel(for indexPath: IndexPath) -> MainLaunchCellViewModel? {
        filteredCellDataSource.value?[indexPath.row]
    }
    
    // MARK: - User Defaults
    private func saveSortOptionToUserDefaults(_ sortOption: SortOption) {
        UserDefaults.standard.set(sortOption.rawValue, forKey: "sort_option")
    }
    
    private func loadSortOptionFromUserDefaults() -> SortOption? {
        guard let rawValue = UserDefaults.standard.string(forKey: "sort_option") else {
            return nil
        }
        return SortOption(rawValue: rawValue)
    }
    
    // MARK: - Search Query
    func updateSearchQuery(_ query: String?) {
        filterLaunches(with: query ?? "")
    }
    
    // MARK: - Helper Methods
    func numberOfSections() -> Int {
        1
    }
    
    func numberOfRows() -> Int {
        self.filteredCellDataSource.value?.count ?? 0
    }
    
}
