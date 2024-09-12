//
//  PartialModalView.swift
//  Test-vacc-Avito
//
//  Created by Alexander Suprun on 12.09.2024.
//

import UIKit

// MARK: Protocol PartialModalViewDelegate

protocol PartialModalViewDelegate: AnyObject {
    // Notifies delegate when a query is selected from the modal view
    func partialModalView(_ view: PartialModalView, didSelectQuery query: String)
}

final class PartialModalView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UI Elements
    private lazy var tableView: UITableView = setupTableView()
    private lazy var verticalStack: UIStackView = setupVerticalStack()
    
    // MARK: - Data
    private var history: [String] = []
    private var suggestions: [String] = []
    
    // MARK: - Delegate
    weak var delegate: PartialModalViewDelegate?
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    // MARK: - Data Loading
    // Retrieves search history from UserDefaults
    private func loadSearchHistory() -> [String] {
        UserDefaults.standard.array(forKey: "searchHistory") as? [String] ?? []
    }
    
    // Updates the data and reloads the table view
    func updateData() {
        history = loadSearchHistory()
        tableView.reloadData()
        updateTableViewHeight()
    }
    
    // Filters search history based on the input query
    func filterHistory(with query: String) {
        suggestions = loadSearchHistory().filter { $0.lowercased().contains(query.lowercased()) }
        updateData()
    }
    
    // Updates the height of the table view dynamically
    private func updateTableViewHeight() {
        let totalHeight = calculateTableViewHeight()
        tableView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = totalHeight
            }
        }
        layoutIfNeeded()
    }
    
    // Calculates the total height required for the table view based on the number of rows and sections
    private func calculateTableViewHeight() -> CGFloat {
        var height: CGFloat = 0
        
        let sections = tableView.numberOfSections
        for section in 0..<sections {
            let rows = tableView.numberOfRows(inSection: section)
            for row in 0..<rows {
                let indexPath = IndexPath(row: row, section: section)
                let rowHeight = tableView.delegate?.tableView?(tableView, heightForRowAt: indexPath) ?? 44
                height += rowHeight
            }
            
            // Adds height for section headers and footers
            let headerHeight = tableView.delegate?.tableView?(tableView, heightForHeaderInSection: section) ?? 0
            height += headerHeight
            
            let footerHeight = tableView.delegate?.tableView?(tableView, heightForFooterInSection: section) ?? 0
            height += footerHeight
        }
        
        return height
    }
    
    // MARK: - Setup Methods
    private func setupTableView() -> UITableView {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.backgroundColor = .settingBackgraound
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }
    
    private func setupVerticalStack() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(tableView)
        addSubview(stack)
        return stack
    }
    
    // Sets up the layout for the stack view and table view
    private func setupLayout() {
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: topAnchor),
            verticalStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            verticalStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            verticalStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Placeholder for dynamic table view height, updated later
            tableView.heightAnchor.constraint(equalToConstant: 0)
        ])
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // Two sections: suggestions and history
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return suggestions.count
        } else {
            return history.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .settingBackgraound
        cell.textLabel?.textColor = .white
          
        if indexPath.section == 0 {
            cell.textLabel?.text = suggestions[indexPath.row]
        } else {
            cell.textLabel?.text = history[indexPath.row]
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedQuery: String
        if indexPath.section == 0 {
            selectedQuery = suggestions[indexPath.row]
        } else {
            selectedQuery = history[indexPath.row]
        }
        delegate?.partialModalView(self, didSelectQuery: selectedQuery)
    }
    
    // Sets the height for each row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44 // Standard row height
    }
    
    // Sets the height for section headers
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else  {
            return 48
        }
    }
    
    // Configures the view for the section headers
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .settingBackgraound
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .white
        label.text = section == 0 ? "" : "History"
        
        headerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
        ])
        
        return headerView
    }
    
    // Sets the height for section footers
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0 // No footer height
    }
}
