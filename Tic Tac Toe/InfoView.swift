//
//  InfoView.swift
//  Tic Tac Toe
//
//  Created by Sung-Jie Hung on 2023/1/30.
//

import UIKit

class InfoView: UIView {
    override func awakeFromNib() {
        // https://developer.apple.com/documentation/objectivec/nsobject/1402907-awakefromnib
        super.awakeFromNib()
        self.layer.cornerRadius = 10.0
        self.layer.backgroundColor = UIColor.black.cgColor
    }
}
