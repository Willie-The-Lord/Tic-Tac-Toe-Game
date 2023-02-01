//
//  ViewController.swift
//  Tic Tac Toe
//
//  Created by Sung-Jie Hung on 2023/1/30.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // Your nine views do not need to be subviews of the GridView, they can be subviews of the view controller's main view.
    // Total 9 squares
    @IBOutlet var square0: UIView!
    @IBOutlet var square1: UIView!
    @IBOutlet var square2: UIView!
    @IBOutlet var square3: UIView!
    @IBOutlet var square4: UIView!
    @IBOutlet var square5: UIView!
    @IBOutlet var square6: UIView!
    @IBOutlet var square7: UIView!
    @IBOutlet var square8: UIView!
    
    @IBOutlet var infoView: InfoView!
    @IBOutlet var infoLabel: UILabel!
    
    @IBOutlet var myButton: UIButton!
    
    @IBOutlet var XPiece: UILabel!
    @IBOutlet var OPiece: UILabel!
    
    // How to add items to an Outlet Collection in Xcode
    // https://stackoverflow.com/questions/45597384/how-to-add-items-to-an-outlet-collection-in-xcode
    @IBOutlet var collectionOfSquares: Array<UIView>?
    
    let grid = Grid()

    override func viewDidLoad() {
        super.viewDidLoad()
        // How to use UIPanGestureRecognizer
        // https://cocoacasts.com/swift-fundamentals-working-with-pan-gesture-recognizers-in-swift
        
        // Construct the first xpiece
        let panGesture1 = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        panGesture1.delegate = self
        XPiece.addGestureRecognizer(panGesture1)
        // Set the xpiece tag
        XPiece.tag = 1
        XPiece.textColor = UIColor.black
        XPiece.layer.borderWidth = 6
        XPiece.layer.borderColor = UIColor.black.cgColor
        XPiece.backgroundColor = UIColor.white

        // Construct the first opiece
        let panGesture2 = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        panGesture2.delegate = self
        OPiece.addGestureRecognizer(panGesture2)
        // Set the opiece tag
        OPiece.tag = 2
        OPiece.textColor = UIColor.black
        OPiece.layer.borderWidth = 6
        OPiece.layer.borderColor = UIColor.black.cgColor
        OPiece.backgroundColor = UIColor.white
        
        // Hide the infoview from your initial iPhone view
        self.infoView.center = CGPoint(x: self.view.center.x, y: -200)
        // https://developer.apple.com/documentation/swift/double/greatestfinitemagnitude
        self.infoView.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        
        // My button UI
        myButton.layer.cornerRadius = 5
        
        // Start from X
        xTurn()
        
        // Debug Area
        // print("great")
    }
    
    func xTurn() {
        UIView.animate(withDuration: 1.2) {
            self.XPiece.alpha = 0.5
        } completion: { (finished) in
        }
        UIView.animate(withDuration: 1.2) {
            self.XPiece.alpha = 1
        } completion: { (finished) in
        }
        self.XPiece.isUserInteractionEnabled = true
        self.OPiece.isUserInteractionEnabled = false
        self.OPiece.alpha = 0.1
    }
    
    func oTurn() {
        UIView.animate(withDuration: 1.2) {
            self.OPiece.alpha = 0.5
        } completion: { (finished) in
        }
        UIView.animate(withDuration: 1.2) {
            self.OPiece.alpha = 1
        } completion: { (finished) in
        }
        self.OPiece.isUserInteractionEnabled = true
        self.XPiece.isUserInteractionEnabled = false
        self.XPiece.alpha = 0.1
    }
    
    @IBAction func tapInfoButton(_ sender: UIButton) {
        infoLabel.text = "Get 3 in a row to win!"
        infoLabel.textColor = UIColor.white
        UIView.animate(withDuration: 1.2) {
            self.infoView.center = self.view.center
        } completion: { (finished) in
        }
    }
    
    @IBAction func tapOkButton(_ sender: UIButton) {
        UIView.animate(withDuration: 1.2) {
            self.infoView.center = CGPoint(x: self.view.center.x, y: 2000)
        } completion: { (finished) in
            self.infoView.center = CGPoint(x: self.view.center.x, y: -200)
        }
        // If game finished -> press to refresh
        if !grid.winner.isEmpty {
            newGame()
        }
    }
    
    // Create new X or O pieces
    func createNewPiece(pieceType: String) -> UILabel {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        panGesture.delegate = self
        if pieceType == "X" {
            let newXpiece = UILabel(frame: CGRect(x: 100, y: 600, width: 80, height: 80))
            newXpiece.text = "X"
            newXpiece.textColor = UIColor.black
            newXpiece.layer.borderWidth = 6
            newXpiece.layer.borderColor = UIColor.black.cgColor
            newXpiece.backgroundColor = UIColor.white
            newXpiece.font = newXpiece.font.withSize(80)
            newXpiece.textAlignment = .center
            newXpiece.tag = 1
            newXpiece.isUserInteractionEnabled = true
            newXpiece.addGestureRecognizer(panGesture)
            view.addSubview(newXpiece)
            return newXpiece
        } else {
            let newOpiece = UILabel(frame: CGRect(x: 226, y: 600, width: 80, height: 80))
            newOpiece.text = "O"
            newOpiece.textColor = UIColor.black
            newOpiece.layer.borderWidth = 6
            newOpiece.layer.borderColor = UIColor.black.cgColor
            newOpiece.backgroundColor = UIColor.white
            newOpiece.font = newOpiece.font.withSize(80)
            newOpiece.textAlignment = .center
            newOpiece.tag = 2
            newOpiece.isUserInteractionEnabled = true
            newOpiece.addGestureRecognizer(panGesture)
            view.addSubview(newOpiece)
            return newOpiece
        }
    }
    
    func compareOverlap(piece: UIView, square: UIView) -> Bool {
        let pieceRec = CGRect(x: piece.center.x, y: piece.center.y, width: 80, height: 80)
        let squareRec = CGRect(x: square.center.x, y: square.center.y, width: 80, height: 80)
        return pieceRec.intersects(squareRec)
    }
    
    // Draw a line with UIBezierPath
    // https://stackoverflow.com/questions/26662415/draw-a-line-with-uibezierpath
    func drawLine(start: Int, end: Int) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: collectionOfSquares![start].center.x, y: collectionOfSquares![start].center.y))
        path.addLine(to: CGPoint(x: collectionOfSquares![end].center.x, y: collectionOfSquares![end].center.y))

        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        shapeLayer.strokeColor = UIColor.systemYellow.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.path = path.cgPath

        view.layer.addSublayer(shapeLayer)
        
        // CATransaction
        // https://developer.apple.com/documentation/quartzcore/catransaction
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            shapeLayer.removeFromSuperlayer()

            UIView.animate(withDuration: 1.0) {
                self.infoView.center = self.view.center
            } completion: { (finished) in
            }
        }
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.duration = 1
        shapeLayer.add(animation, forKey: "MyAnimation")
        CATransaction.commit()
    }
    
    func newGame() {
        // Remove the views
        for subview in view.subviews {
            if subview.tag > 0 {
                subview.removeFromSuperview()
            }
        }
        XPiece = createNewPiece(pieceType: "X")
        OPiece = createNewPiece(pieceType: "O")
        // Clear the grid
        grid.clearGrid()
        // X always starts first
        xTurn()
    }
    
    @objc func didPan(_ recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x: view.center.x + translation.x,
                                  y: view.center.y + translation.y)
            
            recognizer.setTranslation(CGPoint.zero, in: self.view)
            
            // When the pieces are released
            if recognizer.state == .ended {
                var overlapping = false
                for i in 0...8 {
                    // if the target place is empty and overlapping is True
                    if compareOverlap(piece: view, square: collectionOfSquares![i]) &&
                        grid.squares[i] == 0
                    {
                        UIView.animate(withDuration: 1.0) {
                            view.center = self.collectionOfSquares![i].center
                        } completion: { (finished) in
                        }
                        // Change the value of the board
                        grid.squares[i] = view.tag
                        overlapping = true
                        // There is only single place to place the piece
                        break
                    }
                }
                
                if overlapping {
                    view.isUserInteractionEnabled = false
                    if view.tag == 1 {
                        XPiece = createNewPiece(pieceType: "X")
                        oTurn()
                    }
                    else {
                        OPiece = createNewPiece(pieceType: "O")
                        xTurn()
                    }
                } else { // Occupied square or outside the grid
                    if view.tag == 1 {
                        view.center = CGPoint(x: 140, y: 640)
                        xTurn()
                    } else {
                        view.center = CGPoint(x: 266, y: 640)
                        oTurn()
                    }
                }
                
                // Check whether a winner occurs
                grid.check()
                
                // Debug Area
                // print(grid.squares)
                // print(grid.winner)

                if !grid.winner.isEmpty {
                    if grid.winner[0] == 1 {
                        // Once a piece is successfully positioned in an unoccupied space, do NOT allow the user to move it again by chaning the userInteractionEnabled() property.
                        self.XPiece.isUserInteractionEnabled = false
                        self.OPiece.isUserInteractionEnabled = false
                        infoLabel.textColor = UIColor.white
                        self.infoLabel.text = "Congratulations, X wins!"
                        UIView.animate(withDuration: 1.0) {
                            self.infoView.center = self.view.center
                        } completion: { (finished) in
                        }
                        drawLine(start: grid.winner[1], end: grid.winner[2])
                    } else if grid.winner[0] == 2 {
                        self.XPiece.isUserInteractionEnabled = false
                        self.OPiece.isUserInteractionEnabled = false
                        infoLabel.textColor = UIColor.white
                        infoLabel.text = "Congratulations, O wins!"
                        UIView.animate(withDuration: 1.0) {
                            self.infoView.center = self.view.center
                        } completion: { (finished) in
                        }
                        drawLine(start: grid.winner[1], end: grid.winner[2])
                    } else if grid.winner == [3] {
                        self.XPiece.isUserInteractionEnabled = false
                        self.OPiece.isUserInteractionEnabled = false
                        infoLabel.textColor = UIColor.white
                        infoLabel.text = "It is a tie!"
                        UIView.animate(withDuration: 1.0) {
                            self.infoView.center = self.view.center
                        } completion: { (finished) in
                        }
                    }
                }
            }
        }
    }
}
