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
    
    private var clearTextButton: ClearTextButton!
    private var doneTextButton: DoneTextButton!
    
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
        clearTextButton = ClearTextButton()
        doneTextButton = DoneTextButton()
        
        separatorView = HorizontalSeparatorView()
        tableView = UITableView()
        
        // Add the Subviews
        addSubview(clearTextButton)
        addSubview(doneTextButton)
        addSubview(separatorView)
        addSubview(tableView)
        
        
        // Setup the Subviews
        setupSelf()
        setupClearTextButton()
        setupDoneTextButton()
        setupSeparatorView()
        setupTableView()
        
        setupActions()
    }
    
    // MARK: - Actions
    
    private func setupActions() {
        clearTextButton.addTarget(
            self,
            action: #selector(onClearButtonTapped),
            for: .touchUpInside
        )
        
        doneTextButton.addTarget(
            self,
            action: #selector(onDoneButtonTapped),
            for: .touchUpInside
        )
    }
    
    @objc private func onClearButtonTapped() {
        selectedOptions = []
        clearTextButton.isHidden = true
        
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
        
        clearTextButton.isHidden = selectedOptions.isEmpty
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        
        selectedOptions.remove(options[indexPath.row])
        
        clearTextButton.isHidden = selectedOptions.isEmpty
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
        backgroundColor = .popupBackgroundColor
        layer.cornerRadius = .selectViewCornerRadius
    }
    
    private func setupClearTextButton() {
        clearTextButton.isHidden = true
        
        // Constraint Configuration
        clearTextButton.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = clearTextButton.leadingAnchor
            .constraint(equalTo: self.leadingAnchor,
                        constant: .selectViewContentLeadingPadding)
        let top = clearTextButton.topAnchor
            .constraint(equalTo: self.topAnchor,
                        constant: .selectViewContentTopPadding)
        
        NSLayoutConstraint.activate([
            leading, top
        ])
    }
    
    private func setupDoneTextButton() {
        
        // Constraint Configuration
        doneTextButton.translatesAutoresizingMaskIntoConstraints = false
        
        let trailing = doneTextButton.trailingAnchor
            .constraint(equalTo: self.trailingAnchor,
                        constant: .selectContentTrailingPadding)
        let top = doneTextButton.topAnchor
            .constraint(equalTo: self.topAnchor,
                        constant: .selectViewContentTopPadding)
        
        NSLayoutConstraint.activate([
            trailing, top
        ])
    }
    
    private func setupSeparatorView() {
        
        // Constraint Configuration
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = separatorView.leadingAnchor
            .constraint(equalTo: self.leadingAnchor,
                        constant: .selectViewSeparatorLeadingPadding)
        let trailing = separatorView.trailingAnchor
            .constraint(equalTo: self.trailingAnchor,
                        constant: .selectViewSeparatorTrailingPadding)
        let top = separatorView.topAnchor
            .constraint(equalTo: doneTextButton.bottomAnchor,
                        constant: .selectViewSeparatorTopPadding)
        
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
        
        let leading = tableView.leadingAnchor
            .constraint(equalTo: separatorView.leadingAnchor)
        let trailing = tableView.trailingAnchor
            .constraint(equalTo: separatorView.trailingAnchor)
        let top = tableView.topAnchor
            .constraint(equalTo: separatorView.bottomAnchor,
                        constant: .selectViewTableTopPadding)
        let bottom = tableView.bottomAnchor
            .constraint(equalTo: self.bottomAnchor,
                        constant: .selectContentTrailingPadding)
        
        NSLayoutConstraint.activate([
            leading, trailing, top, bottom
        ])
    }
    
}
