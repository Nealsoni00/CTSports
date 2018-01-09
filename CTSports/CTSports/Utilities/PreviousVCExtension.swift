//
//  PreviousVCExtension.swift
//  CTSports
//
//  Created by Jack Sharkey on 1/8/18.
//  Copyright © 2018 Neal Soni. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewController {
    func backViewController() -> UIViewController? {
        if let stack = self.navigationController?.viewControllers {
            for i in (1..<stack.count).reversed() {
                if(stack[i] == self) {
                    return stack[i-1]
                }
            }
        }
        return nil
    }
}
