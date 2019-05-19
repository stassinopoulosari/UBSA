//
//  UBSAClassNameTableViewController.swift
//  UBSA
//
//  Created by Ari Stassinopoulos on 5/18/19.
//  Copyright © 2019 Ari Stassinopoulos. All rights reserved.
//

import UIKit;
import UBSAKit;

class ClassNameTableViewController: UITableViewController {

    public var currentSymbols: UBSASymbols?;
    
    private var configurableSymbols: [UBSASymbol] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findConfigurable();
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "All changes are saved automatically."
    }

    private func findConfigurable() {
        if let symbols = currentSymbols {
            configurableSymbols = symbols.symbols.filter { (symbol) -> Bool in
                return symbol.configurable;
            };
            configurableSymbols.sort { (a, b) -> Bool in
                return a.defaultValue < b.defaultValue;
            };
        }
        self.tableView?.reloadData();
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return configurableSymbols.count;
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "classNameCell", for: indexPath);
        
        if let classNameCell = cell as? SymbolCell {
            classNameCell.symbol = self.configurableSymbols[indexPath.row];
            classNameCell.render();
            cell = classNameCell;
        }

        return cell;
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0;
    }
}
