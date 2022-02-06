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
        selectedOption = ""
        clearButton.isHidden = true
        
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
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        Logger.debug("didMoveToWindow")
    }
}

// MARK: - UITableViewDelegate

extension UniSelectView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard selectedOption.isEmpty else {
            tableView.deselectRow(at: indexPath, animated: false)
            self.tableView(tableView, didDeselectRowAt: indexPath)
            return
        }
        selectedOption = options[indexPath.row]
        
        clearButton.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedOption = ""
        
        clearButton.isHidden = true
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
        
        let option = options[indexPath.row]
        
        cell.backgroundColor = .clear
        cell.textLabel?.text = option
        
        return cell
    }
    
}


// MARK: - Subviews Configurations

extension UniSelectView {
    
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
        tableView.allowsSelection = true
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BasicCell")
        
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
