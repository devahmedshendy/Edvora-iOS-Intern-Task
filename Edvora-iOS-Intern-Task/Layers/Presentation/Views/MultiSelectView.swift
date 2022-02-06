//
//  MultiSelectView.swift
//  Edvora-iOS-Intern-Task
//
//  Created by Ahmed Shendy on 2/5/22.
//

import UIKit

final class MultiSelectView: UIView {
    
    // MARK: - Properties
    
    private var selectedOptions: Set<String> = []
    
    private var options: [String] = []
    
    var onSelectionDone: (([String]) -> Void)!
    
    // MARK: - Subviews
    
    private var clearButton: ClearButton!
    private var doneButton: DoneButton!
    
    private var separatorView: HorizontalSeparatorView!
    
    private var tableView: UITableView!
    
    // MARK: - inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    func setup() {
        // Create the Subviews
        clearButton = ClearButton()
        doneButton = DoneButton()
        
        separatorView = HorizontalSeparatorView()
        tableView = UITableView()
        
        // Add the Subviews
        addSubview(clearButton)
        addSubview(doneButton)
        addSubview(separatorView)
        addSubview(tableView)
        
        
        // Setup the Subviews
        setupSelf()
        setupClearButton()
        setupDoneButton()
        setupSeparatorView()
        setupTableView()
        
        setupActions()
    }
    
    // MARK: - Actions
    
    private func setupActions() {
        clearButton.addTarget(
            self,
            action: #selector(onClearButtonTapped),
            for: .touchUpInside
        )
        
        doneButton.addTarget(
            self,
            action: #selector(onDoneButtonTapped),
            for: .touchUpInside
        )
    }
    
    @objc private func onClearButtonTapped() {
        selectedOptions = []
        clearButton.isHidden = true
        
        tableView
            .indexPathsForSelectedRows?
            .compactMap(tableView.cellForRow(at:))
            .forEach {
                $0.accessoryType = .none
                $0.setSelected(false, animated: false)
            }
        
        tableView.reloadData()
    }
    
    @objc private func onDoneButtonTapped() {
        onSelectionDone(Array(selectedOptions))
    }
    
    // MARK: - Helpers
    
    func reloadWith(list: [String], previousSelections: [String]) {
        options = list
        
        tableView.reloadData()
        handlePreviousSelections(previousSelections)
    }
    
    private func handlePreviousSelections(_ previousSelections: [String]) {
        guard previousSelections.isNotEmpty else { return }
        
        selectedOptions = Set(previousSelections)
                
        options
            .enumerated()
            .filter { (index, option) in
                selectedOptions.contains(option)
            }
            .map { (index, _) in IndexPath(row: index, section: 0) }
            .forEach { indexPath in
                tableView.selectRow(at: indexPath,
                                    animated: false,
                                    scrollPosition: .none)
                tableView(tableView, didSelectRowAt: indexPath)
            }
    }
}

// MARK: - UITableViewDelegate

extension MultiSelectView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        selectedOptions.insert(options[indexPath.row])
        
        clearButton.isHidden = selectedOptions.isEmpty
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        
        selectedOptions.remove(options[indexPath.row])
        
        clearButton.isHidden = selectedOptions.isEmpty
    }
    
}

// MARK: - UITableViewDataSource

extension MultiSelectView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectViewCell.reuseIdentifier, for: indexPath) as! SelectViewCell
        
        let option = options[indexPath.row]
        
        cell.textLabel?.text = option
        cell.accessoryType = selectedOptions.contains(option) ? .checkmark : .none
        
        return cell
    }
    
}


// MARK: - Subviews Configurations

extension MultiSelectView {
    
    private func setupSelf() {
        clipsToBounds = true
        backgroundColor = .filtersBackgroundColor
        layer.cornerRadius = .filterViewCornerRadius
    }
    
    private func setupClearButton() {
        clearButton.isHidden = true
        
        // Constraint Configuration
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = clearButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20)
        let top = clearButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 15)
        
        NSLayoutConstraint.activate([
            leading, top
        ])
    }
    
    private func setupDoneButton() {
        
        // Constraint Configuration
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        let trailing = doneButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        let top = doneButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 15)
        
        NSLayoutConstraint.activate([
            trailing, top
        ])
    }
    
    private func setupSeparatorView() {
        
        // Constraint Configuration
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = separatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15)
        let trailing = separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15)
        let top = separatorView.topAnchor.constraint(equalTo: doneButton.bottomAnchor, constant: 5)
        
        NSLayoutConstraint.activate([
            leading, trailing, top
        ])
    }
    
    private func setupTableView() {
        tableView.allowsMultipleSelection = true
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(SelectViewCell.self, forCellReuseIdentifier: SelectViewCell.reuseIdentifier)
        
        // Constraint Configuration
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = tableView.leadingAnchor.constraint(equalTo: separatorView.leadingAnchor)
        let trailing = tableView.trailingAnchor.constraint(equalTo: separatorView.trailingAnchor)
        let top = tableView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 10)
        let bottom = tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        
        NSLayoutConstraint.activate([
            leading, trailing, top, bottom
        ])
    }
    
}
