//
//  SettingViewController.swift
//  Test-vacc-Avito
//
//  Created by Alexander Suprun on 11.09.2024.
//

import UIKit
import Foundation

// MARK: - Protocol SettingViewControllerDelegate

protocol SettingViewControllerDelegate: AnyObject {
    func didUpdateSearchParameters(_ parameters: SearchParameters)
}

// MARK: - SettingViewController

final class SettingViewController: UIViewController {
    
    // MARK: - UI Elements
    private lazy var tableView: UITableView = setupTableView()
    private lazy var applyButton: UIButton = setupApplyButton()

    private let sections: [Section] = [
        Section(
            title: "SORT BY",
            options: [
                Option(title: "Relevance", color: nil),
                Option(title: "Newest", color: nil)
            ]),
        Section(
            title: "ORIENTATION",
            options: [
                Option(title: "Any", color: nil),
                Option(title: "Portrait", color: nil),
                Option(title: "Landscape", color: nil),
                Option(title: "Square", color: nil)
            ]),
        Section(
            title: "COLOR",
            options: [
                Option(title: "Any", color: UIColor.clear),
                Option(title: "BlackAndWhite", color: UIColor.black),
                Option(title: "Black", color: UIColor.black),
                Option(title: "White", color: UIColor.white),
                Option(title: "Yellow", color: UIColor.yellow),
                Option(title: "Orange", color: UIColor.orange),
                Option(title: "Red", color: UIColor.red),
                Option(title: "Purple", color: UIColor.purple),
                Option(title: "Magenta", color: UIColor.magenta),
                Option(title: "Green", color: UIColor.green),
                Option(title: "Teal", color: UIColor.cyan),
                Option(title: "Blue", color: UIColor.blue)
            ]
        )
    ]
    private var selectedSortingOption: String?
    private var selectedOrientationOption: String?
    private var selectedColorOption: String?
    
    weak var delegate: SettingViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedSortingOption = UserDefaults.standard.string(forKey: "sortBy") ?? sections[0].options.first?.title
         selectedOrientationOption = UserDefaults.standard.string(forKey: "orientation") ?? sections[1].options.first?.title
         selectedColorOption = UserDefaults.standard.string(forKey: "color") ?? sections[2].options.first?.title

        view.backgroundColor = Colors.settingTableColor
        setupLayout()
    }
    
    private func setupTableView() -> UITableView {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        table.register(ColorSettingTableViewCell.self, forCellReuseIdentifier: "ColorSettingCell")
        table.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(table)
        return table
    }
    
    private func setupApplyButton() -> UIButton {
        let button = UIButton()
        button.setTitle("Apply", for: .normal)
        button.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
        button.backgroundColor = Colors.settingTableColor
        button.layer.borderWidth = 1
        button.titleLabel?.textColor = .white
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        return button
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: applyButton.topAnchor, constant: -16),
            
            applyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            applyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            applyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            applyButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    @objc private func applyButtonTapped() {
        UserDefaults.standard.setValue(selectedSortingOption, forKey: "sortBy")
        UserDefaults.standard.setValue(selectedOrientationOption, forKey: "orientation")
        UserDefaults.standard.setValue(selectedColorOption, forKey: "color")

        // Передача параметров делегату
        let parameters = SearchParameters(
            sortBy: selectedSortingOption ?? "Relevance",
            orientation: selectedOrientationOption ?? "Any",
            color: selectedColorOption ?? "Any"
        )
        
        delegate?.didUpdateSearchParameters(parameters)
        
        dismiss(animated: true, completion: nil)
    }

}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let option = section.options[indexPath.row]
        
        if section.title == "COLOR" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ColorSettingCell", for: indexPath) as! ColorSettingTableViewCell
            cell.contentView.backgroundColor = Colors.settingTableColor

            let isSelected = option.title == selectedColorOption
            cell.configure(with: option.color ?? UIColor.clear, title: option.title, isSelected: isSelected)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
            
            let isSelected = (section.title == "SORT BY" && option.title == selectedSortingOption) ||
                             (section.title == "ORIENTATION" && option.title == selectedOrientationOption)
            
            cell.configure(title: option.title, isSelected: isSelected)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        let option = section.options[indexPath.row]
        
        switch section.title {
        case "SORT BY":
            selectedSortingOption = option.title
        case "ORIENTATION":
            selectedOrientationOption = option.title
        case "COLOR":
            selectedColorOption = option.title
        default:
            break
        }
        
        tableView.reloadData()
    }
}
