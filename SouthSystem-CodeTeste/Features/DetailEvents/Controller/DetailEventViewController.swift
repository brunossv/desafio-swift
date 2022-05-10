//
//  DetailEventViewController.swift
//  SouthSystem-CodeTeste
//
//  Created by Bruno Vieira on 10/05/22.
//

import Foundation
import UIKit

class DetailEventViewController : UIViewController {
    
    private enum Cells: String, CaseIterable {
        case detail = "DetailEventTableViewCell"
        
        var `class`: AnyClass? {
            switch self {
            case .detail:
                return DetailEventTableViewCell.self
            }
        }
    }
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var viewModel: DetailEventViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadData()
    }
    
    private func loadData() {
        self.viewModel?.loadData { [weak self] error in
            self?.tableView.refreshControl?.endRefreshing()
            if let msgError = error {
                let alertViewController = UIAlertController(title: "SouthSystem", message: msgError, preferredStyle: .alert)
                let actionOk = UIAlertAction(title: "OK", style: .default) { _ in
                    
                }
                alertViewController.addAction(actionOk)
                self?.present(alertViewController, animated: true, completion: nil)
                
                return
            }
            
            self?.tableView.reloadData()
        }
    }
    
    private func configureTableView() {
        self.view.addSubview(self.tableView)
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = false
        for cell in Cells.allCases {
            self.tableView.register(cell.class, forCellReuseIdentifier: cell.rawValue)
        }
    }
}

extension DetailEventViewController: UITableViewDelegate {
    
}

extension DetailEventViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.model != nil ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        func dequeue<T: UITableViewCell>(_ tableView: UITableView, with identifier: String,_ indexPath: IndexPath) -> T {
            if let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T {
                return cell
            } else {
                return T(style: .default, reuseIdentifier: identifier)
            }
        }
        
        let cell: DetailEventTableViewCell = dequeue(tableView, with: Cells.detail.rawValue, indexPath)
        let model = self.viewModel?.model
        cell.title = model?.title
        cell.desc = model?.description
        cell.image = model?.image
        
        return cell
    }
}