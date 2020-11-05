//
//  AvalancheTableViewController.swift
//
//  Created by Phil Scarfi on 3/8/20.
//  Copyright © 2020 Pioneer Mobile Applications, LLC. All rights reserved.
//

import UIKit

protocol AvalancheTableViewDataSource {
    ///Number of Parent Cells that will be shown
    func numberOfCells(in avalancheTableView: AvalancheTableViewController) -> Int
    ///Number of sub cells to be shown when parent is expanded
    func numberOfSubCells(_ avalancheTableView: AvalancheTableViewController, numberOfRowsInParent parentRow: Int) -> Int
    ///The cell to be used for a parent row
    func avalanchTableView(_ avalancheTableView: AvalancheTableViewController, parentCellForRowAt row: Int) -> UITableViewCell
    ///The cell to be used for a sub cell
    func avalanchTableView(_ avalancheTableView: AvalancheTableViewController, cellForSubRow parentRow: Int, subRow: Int) -> UITableViewCell
}

protocol AvalancheTableViewDelegate {
    func avalanchTableView(_ avalancheTableView: AvalancheTableViewController, didSelectParentAtRow row: Int)
    func avalanchTableView(_ avalancheTableView: AvalancheTableViewController, didSelectSubRowAt parentRow: Int, subRow: Int)
}

class AvalancheTableViewController: UIViewController {
 
    let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    var dataSource: AvalancheTableViewDataSource?
    var delegate: AvalancheTableViewDelegate?

    private var openedRows = [Int:Bool]() //Closed by default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupTableView() {
         view.addSubview(tableView)
         tableView.translatesAutoresizingMaskIntoConstraints = false
         tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
         tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
         tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
         tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
         tableView.rowHeight = UITableView.automaticDimension
         tableView.estimatedRowHeight = 40
         tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 0.1))
        tableView.sectionFooterHeight = 0.1;

       }
    
    
    //MARK: - Public Functions
    func addToViewController(vc: UIViewController, view: UIView? = nil) {
        vc.addAChild(page: self, toView: view ?? vc.view)
        reload()
    }
    
    func remove() {
        removeVCAsChild()
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    func indexPathFor(parentRow: Int, subRow: Int) -> IndexPath {
        return IndexPath(row: subRow, section: parentRow)
    }
    
}



extension AvalancheTableViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource?.numberOfCells(in: self) ?? 0
    }
       
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if openedRows[section] == true {
            return dataSource?.numberOfSubCells(self, numberOfRowsInParent: section) ?? 0
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let view = dataSource?.avalanchTableView(self, parentCellForRowAt: section) {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didSelectHeader(_:)))
            view.addGestureRecognizer(tapGesture)
            view.tag = section
            return view
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dataSource?.avalanchTableView(self, cellForSubRow: indexPath.section, subRow: indexPath.row) ?? UITableViewCell()
    }
    
    
}

extension AvalancheTableViewController: UITableViewDelegate {
    
    @objc func didSelectHeader(_ tapGesture: UITapGestureRecognizer) {
        if let view = tapGesture.view {
            let section = view.tag
            
            let numberOfSubCells = dataSource?.numberOfSubCells(self, numberOfRowsInParent: section) ?? 0
            var indexPaths = [IndexPath]()
            if numberOfSubCells > 0 {
                for i in 0...numberOfSubCells - 1 {
                    indexPaths.append(IndexPath(row: i, section: section))
                }
                
                tableView.performBatchUpdates({
                    if openedRows[section] == true {
                        self.tableView.deleteRows(at: indexPaths, with: .automatic)
                    } else {
                        self.tableView.insertRows(at: indexPaths, with: .automatic)
                    }
                    openedRows[section] = (openedRows[section] == true) ? false : true
                }, completion: { finished in
                    self.tableView.reloadData()
                })
            }
            delegate?.avalanchTableView(self, didSelectParentAtRow: section)
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.avalanchTableView(self, didSelectSubRowAt: indexPath.section, subRow: indexPath.row)
    }
}


extension UIViewController {
    fileprivate func addAChild(page: UIViewController, toView: UIView) {
              addChild(page)
              page.view.frame = CGRect(origin: CGPoint.zero, size: toView.frame.size)
              toView.addSubview(page.view)
              page.didMove(toParent: self)
          }
          
    fileprivate func removeVCAsChild() {
              willMove(toParent: nil)
              view.removeFromSuperview()
              removeFromParent()
          }
}

