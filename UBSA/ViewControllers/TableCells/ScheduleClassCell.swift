//
//  ScheduleClassCell.swift
//  UBSA
//
//  Created by Ari Stassinopoulos on 5/16/19.
//  Copyright © 2019 Ari Stassinopoulos. All rights reserved.
//

import UIKit

class ScheduleClassCell: UITableViewCell {

    @IBOutlet var labelField: UILabel!;
    @IBOutlet var startAndEndField: UILabel!;
    @IBOutlet var fallbackField: UILabel!;
    
    public static let HEIGHT_NORMAL = 44;
    public static let HEIGHT_SMALL = 35;
    
    private var baseFont: UIFont?;
    
    public func boldText() {
        let font = UIFont.boldSystemFont(ofSize: 17.0);
        [labelField, startAndEndField].forEach { (label) in
            if let l = label {
                l.font = font;
            }
        }
    }
    
    public func normalText() {
        if let font = baseFont {
            [labelField, startAndEndField].forEach { (label) in
                if let l = label {
                    l.font = font;
                }
            }
        }
    }
    
    public func unboldText() {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.baseFont = labelField.font;
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
