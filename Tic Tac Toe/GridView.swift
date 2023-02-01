//
//  GridView.swift
//  Tic Tac Toe
//
//  Created by Sung-Jie Hung on 2023/1/30.
//

//import Foundation
import UIKit

// The GridView will provide the visual game board of vertical and horizontal lines.
class GridView: UIView {
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {

        let path = UIBezierPath()
        
        // Two vertical lines
        path.move(to: CGPoint(x: 100, y: 0))
        path.addLine(to: CGPoint(x: 100, y: 300))
        path.move(to: CGPoint(x: 200, y: 0))
        path.addLine(to: CGPoint(x: 200, y: 300))
        
        // Two horizontal lines
        path.move(to: CGPoint(x: 0, y: 100))
        path.addLine(to: CGPoint(x: 300, y: 100))
        path.move(to: CGPoint(x: 0, y: 200))
        path.addLine(to: CGPoint(x: 300, y: 200))
        
        // Set color of the lines
        UIColor.black.setStroke()
        path.lineWidth = 10
        path.stroke()
    }
}
