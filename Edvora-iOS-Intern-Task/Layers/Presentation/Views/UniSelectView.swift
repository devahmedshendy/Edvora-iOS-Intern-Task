//
//  UniSelectView.swift
//  Edvora-iOS-Intern-Task
//
//  Created by Ahmed Shendy on 2/6/22.
//

import UIKit

final class UniSelectView: UIView {
    
    // MARK: - Properties
    
    private var selectedOption: String = ""
    private var options: [String] = []
    
    var onSelectionDone: ((String) -> Void)!
    
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
        selectedOption = ""
        clearTextButton.isHidden = true
        
        tableView
            .indexPathsForSelectedRows?
            .compactMap(tableView.cellForRow(at:))
            .forEach {
                $0.setSelected(false, animated: false)
            }
        
        tableView.reloadData()
    }
    
    @objc private func onDoneButtonTapped() {
        onSelectionDone(selectedOption)
    }
    
    // MARK: - Helpers
    
    func reloadWith(list: [String], previousSelection: String) {
        options = list
        
        tableView.reloadData()
        handlePreviousSelection(previousSelection)
    }
    
    private func handlePreviousSelection(_ previousSelection: String) {
        guard previousSelection.isNotEmpty else { return }
        
        selectedOption = previousSelection
        
        if let optionIndex = options.firstIndex(where: { $0 == selectedOption }) {
            let indexPath = IndexPath(row: optionIndex, section: 0)
            tableView.selectRow(at: indexPath,
                                animated: false,
                                scrollPosition: .none)
            tableView(tableView, didSelectRowAt: indexPath)
        }
    }
    
}

// MARK: - UITableViewDelegate

extension UniSelectView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedOption = options[indexPath.row]
        
        clearTextButton.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedOption = ""
        
        clearTextButton.isHidden = true
    }
    
}

// MARK: - UITableViewDataSource

extension UniSelectView: UITableViewDataSource {
    
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
        
        return cell
    }
    
}


// MARK: - Subviews Configurations

extension UniSelectView {
    
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
        tableView.allowsSelection = true
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
