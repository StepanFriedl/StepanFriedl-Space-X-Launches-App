//
//  MainViewController+TableView.swift
//  Space-X-Launches-App
//
//  Created by Štěpán Friedl on 15.09.2024.
//

import UIKit

extension MainViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // MARK: - TableView Setup
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = .clear
        
        setupTableHeader()
        registerCells()
    }

    func registerCells() {
        tableView.register(MainLaunchCell.register(), forCellReuseIdentifier: MainLaunchCell.identifier)
    }
    
    func setupTableHeader() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        let searchTextField = UITextField(frame: CGRect(x: 10, y: 10, width: headerView.frame.width - 20, height: 30))
        searchTextField.placeholder = "searchLaunchesByName".localized()
        searchTextField.borderStyle = .roundedRect
        searchTextField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        
        setupKeyboardToolbar(for: searchTextField)
        searchTextField.delegate = self
        
        headerView.addSubview(searchTextField)
        tableView.tableHeaderView = headerView
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainLaunchCell.identifier, for: indexPath) as? MainLaunchCell else {
            return UITableViewCell()
        }
        
        if let cellViewModel = viewModel.cellViewModel(for: indexPath) {
            cell.setupCell(viewModel: cellViewModel)
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let launchID = viewModel.filteredCellDataSource.value?[indexPath.row].id {
            self.openDetail(launchID)
        }
        dismissKeyboard()
    }
    
    // MARK: - TableView Reloading
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Search and Keyboard Handling
    func setupKeyboardToolbar(for textField: UITextField) {
        let toolbar = UIToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "done".localized(), style: .done, target: self, action: #selector(dismissKeyboard))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [spacer, doneButton]
        textField.inputAccessoryView = toolbar
    }


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }

    @objc func dismissKeyboard() {
        DispatchQueue.main.async {
            self.view.endEditing(true)
        }
    }
    
    @objc func searchTextChanged(_ textField: UITextField) {
        viewModel.updateSearchQuery(textField.text)
    }
    
}
