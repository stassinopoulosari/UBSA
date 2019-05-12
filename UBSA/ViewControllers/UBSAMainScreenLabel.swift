//
//  UBSAMainScreenLabel.swift
//  UBSA
//
//  Created by Ari Stassinopoulos on 5/8/19.
//  Copyright © 2019 Ari Stassinopoulos. All rights reserved.
//

import UIKit

/** 
 Label which automatically changes to UBSAColour suggested colour
 */

class UBSAMainScreenLabel: UILabel {

    //MARK: - Initialisers
    
    ///Frame initializer: needed for custom colour
    override public init(frame: CGRect) {
        super.init(frame: frame);
        self.textColor = UBSAAppConfig.sharedContext.textColour;
        self.tintColor = UBSAAppConfig.sharedContext.textColour;
    }
    
    ///Coder initializer: needed for custom colour
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
            self.textColor = UBSAAppConfig.sharedContext.textColour;
            self.tintColor = UBSAAppConfig.sharedContext.textColour;
        
    }
    
    
}
