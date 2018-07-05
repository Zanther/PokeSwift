//
//  PokeSearchBar.swift
//  PokeSwift
//
//  Created by Steven Lattenhauer 2nd on 7/5/18.
//  Copyright © 2018 Steven Lattenhauer 2nd. All rights reserved.
//

import UIKit

class PokeSearchBar: UISearchBar {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        tintColor = .white
        setImage(UIImage(named: "search-icon"), for: UISearchBarIcon.search, state: .normal)
        setImage(UIImage(named: "clear-search"), for: UISearchBarIcon.clear, state: .normal)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Enter Pokemon Name", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
    }

}
