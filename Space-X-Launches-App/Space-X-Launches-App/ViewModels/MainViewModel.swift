//
//  MainViewModel.swift
//  Space-X-Launches-App
//
//  Created by Štěpán Friedl on 15.09.2024.
//

import Foundation

class MainViewModel {
    
    var isLoading: Observable<Bool> = Observable(false)
    var cellDataSource: Observable<[MainLaunchCellViewModel]> = Observable(nil)
    var dataSource: PastLaunches?
    
    func numberOfSections() -> Int {
        1
    }
    
    func numberOfRows() -> Int {
        self.dataSource?.count ?? 0
    }
    
    func getData() {
        if isLoading.value ?? true {
            return
        }
        isLoading.value = true
        APICaller.getPastLaunches { [weak self] result in
            self?.isLoading.value = false
            switch result {
            case .success(let data):
                print("Data count: \(data.count)")
                self?.dataSource = data
                self?.mapCellData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func mapCellData() {
        self.cellDataSource.value = self.dataSource?.compactMap { MainLaunchCellViewModel(launch: $0) }
    }
    
    func getCellTitle(_ launch: Launch) -> String {
        return launch.name ?? ""
    }
    
    func retrieveLaunch(with id: String) -> Launch? {
        dataSource?.first(where: { $0.id == id })
    }
    
}
