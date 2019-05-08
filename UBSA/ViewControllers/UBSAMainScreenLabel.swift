//
//  UBSAMainScreenLabel.swift
//  UBSA
//
//  Created by Ari Stassinopoulos on 5/8/19.
//  Copyright © 2019 Ari Stassinopoulos. All rights reserved.
//

import UIKit

class UBSAMainScreenLabel: UILabel {

    ///Frame initializer: needed for custom colour
    override init(frame: CGRect) {
        super.init(frame: frame);
        textColor = UBSAAppConfig.c.textColour;
        tintColor = UBSAAppConfig.c.textColour;

    }
    
    ///Coder initializer: needed for custom colour
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        textColor = UBSAAppConfig.c.textColour;
        tintColor = UBSAAppConfig.c.textColour;
    }
    
    
}
