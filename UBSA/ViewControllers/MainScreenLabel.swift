//
//  MainScreenLabel.swift
//  UBSA
//
//  Created by Ari Stassinopoulos on 5/8/19.
//  Copyright © 2019 Ari Stassinopoulos. All rights reserved.
//

import UIKit

/** 
 Label which automatically changes to UBSAColour suggested colour
 */

class MainScreenLabel: UILabel {

    //MARK: - Initialisers
    
    ///Frame initializer: needed for custom colour
    override public init(frame: CGRect) {
        super.init(frame: frame);
        self.textColor = AppConfig.C.textColour;
        self.tintColor = AppConfig.C.textColour;
    }
    
    ///Coder initializer: needed for custom colour
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
            self.textColor = AppConfig.C.textColour;
            self.tintColor = AppConfig.C.textColour;
        
    }
    
    
}
