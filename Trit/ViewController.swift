//
//  ViewController.swift
//  Trit
//
//  Created by Sergio Hernandez on 26/06/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import Cocoa

struct Tri {
    
    var children = [Node:[Node]]()
    var parent = [Node:Node?]()
    var root = Node()
    var constraints = [Node:[NSLayoutConstraint]]()
    
}

class ViewController: NSViewController {

    public var currentRoot: Node!
    public var tree: Tri!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let root = Node(frame: CGRect(x: 192, y: 228, width: 100, height: 50))
        root.treeView = self
        self.view.addSubview(root)
        currentRoot = root
        configureArea(of: root)
        // Constraints of the root
        root.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalConstraint = NSLayoutConstraint(item: root, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: root, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 50)
        let widthConstraint = NSLayoutConstraint(item: root, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        let heightConstraint = NSLayoutConstraint(item: root, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)

        self.view.addConstraints([horizontalConstraint, verticalConstraint, heightConstraint, widthConstraint])

        
        // Create the tree
        tree = Tri(children: [root:[]], parent: [root:nil], root: root, constraints: [root:[]])
    }
    
    public func configureArea(of node: Node) {
        // Add a tracking area (detects the cursor over a node)
        let opts: NSTrackingAreaOptions = ([NSTrackingAreaOptions.mouseEnteredAndExited, NSTrackingAreaOptions.activeAlways])
        node.trackingArea = NSTrackingArea(rect: node.bounds, options: opts, owner: node, userInfo: nil)
        node.addTrackingArea(node.trackingArea)
    }
    
    public func configureConstraints(of node: Node, withParent parent: Node) {
        // Constraints of the new node
        node.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalConstraint = NSLayoutConstraint(item: node, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: node, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: parent, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 100)
        let widthConstraint = NSLayoutConstraint(item: node, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 100)
        let heightConstraint = NSLayoutConstraint(item: node, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
        
        self.view.addConstraints([horizontalConstraint, verticalConstraint, heightConstraint, widthConstraint])
        tree.constraints[node] = [horizontalConstraint, verticalConstraint, heightConstraint, widthConstraint]
        
        //// Configure all the children to form a row
        //// Keep in mind that 0 = horizontalConstraint, 1 = verticalConstraint, 2 = heightConstraint, 3 = widthConstraint
        let countChildren = (tree.children[parent]?.count)!
        var allChildren = tree.children[parent]!
        var centerChild1: Node?
        var centerChild2: Node?
        
        // No children
        if countChildren == 0 {}
            
        // Configure the center 2 children (if number of children is even)
        else if countChildren % 2 == 0 {
            centerChild1 = allChildren[countChildren/2 - 1]
            centerChild2 = allChildren[countChildren/2]
            tree.constraints[centerChild1!]![0].constant = 150
            tree.constraints[centerChild2!]![0].constant = 150
            
        // Configure the center child (if number of children is odd)
        } else {
            centerChild1 = allChildren[countChildren/2]
            centerChild2 = nil
            tree.constraints[centerChild1!]![0].constant = 0
        }
        
        // Configure the rest of children
        var distance: CGFloat
        if centerChild2 == nil {
            distance = CGFloat((-100)*(countChildren/2 - 1))
        }
        else {
            distance = CGFloat(((-100)*(countChildren/2)) + 50)
        }
        for child in allChildren {
            if child != allChildren[0] && child != centerChild1 && child != centerChild2 {
                tree.constraints[child]![0].constant = distance
            }
            distance += 100
        }
        
        self.view.layoutSubtreeIfNeeded()

    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

