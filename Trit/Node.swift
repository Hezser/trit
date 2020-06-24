//
//  Node.swift
//  Trit
//
//  Created by Sergio Hernandez on 26/06/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import Cocoa
import Foundation

class Node: NSTextField {
    
    var parent: Node! // Need to configure in the view controllers
    var children: [Node] = [] // Need to configure in the view controllers
    public var treeView: ViewController!
    public var trackingArea: NSTrackingArea!
    var addChildButton: NSButton!
    var removeNodeButton: NSButton!
    
    override func mouseEntered(with event: NSEvent) {
        Swift.print("IN")
        treeView.currentRoot = self
        var verticalConstraint: NSLayoutConstraint, horizontalConstraint: NSLayoutConstraint, widthConstraint: NSLayoutConstraint, heightConstraint: NSLayoutConstraint
        // Add button which adds a child to the node when pressed
        if addChildButton == nil {
            addChildButton = NSButton(title: "+", target: self, action: #selector(addChild))
            addChildButton.frame = CGRect(x: treeView.currentRoot.frame.origin.x + 90, y: treeView.currentRoot.frame.origin.y + 20, width: treeView.currentRoot.frame.height - 10, height: treeView.currentRoot.frame.height - 10)
            treeView.view.addSubview(addChildButton)
            // Constraints for the button
            addChildButton.translatesAutoresizingMaskIntoConstraints = false
            
            verticalConstraint = NSLayoutConstraint(item: addChildButton, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 15)
            horizontalConstraint = NSLayoutConstraint(item: addChildButton, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 65)
            widthConstraint = NSLayoutConstraint(item: addChildButton, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 25)
            heightConstraint = NSLayoutConstraint(item: addChildButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 25)
            
            addChildButton.addConstraints([horizontalConstraint, verticalConstraint, heightConstraint, widthConstraint])
        }
        
        // Add button which removes the node when pressed
        if removeNodeButton == nil && self != treeView.tree.root {
            removeNodeButton = NSButton(title: "-", target: self, action: #selector(removeNode))
            removeNodeButton.frame = CGRect(x: treeView.currentRoot.frame.origin.x + 90, y: treeView.currentRoot.frame.origin.y - 18, width: treeView.currentRoot.frame.height - 10, height: treeView.currentRoot.frame.height - 10)
            treeView.view.addSubview(removeNodeButton)
            // Constraints for the button
            removeNodeButton.translatesAutoresizingMaskIntoConstraints = false
            
            verticalConstraint = NSLayoutConstraint(item: removeNodeButton, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 40)
            horizontalConstraint = NSLayoutConstraint(item: removeNodeButton, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 65)
            widthConstraint = NSLayoutConstraint(item: removeNodeButton, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 25)
            heightConstraint = NSLayoutConstraint(item: removeNodeButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 25)
            
            removeNodeButton.addConstraints([horizontalConstraint, verticalConstraint, heightConstraint, widthConstraint])
        }
    }
    
//    func someFunctionToDetectTheMouseLevingTheTextField() {
//        Swift.print("OUT")
//        addChildButton.removeFromSuperview()
//        removeNodeButton.removeFromSuperview()
//    }
    
    func adaptChildrenConstraints() {
        // Let the constant separation between nodes be 100
        let n = children.count
        var distance: Int
        
        // No children
        if n == 0 {}
        // If the number of children is odd, then the center child will be inmediately below the parent
        else if n % 2 != 0 {
            distance = (n-1)/2 * -100 // Where 100 is, again, the constant separation, which could be edited for better design; also, we make it negative since we start by the children left to the parent node
        }
        // Else if the number of children is even, then the 2 center children will be fomring a triangle with the parent (NOTE 1: I hope this makes sense, if not fire yourself from this company and go back to primary school, thanks!)
        else {
            distance = ((n/2) * -100) + 50 // Where 50 is half of the constant between nodes (100/2 = 50; if you read this refer to NOTE 1)
        }
        
        for child in children {
            // Knowing that the horizontal constraint will always be the first one:
            child.constraints.first?.constant = CGFloat(distance)
            distance += 100
        }
        
        // Reload View Constraints
        self.view.layoutSubtreeIfNeeded()
    }
    
    func addChild() {
        let newChild = Node(frame: CGRect(x: self.frame.origin.x, y: self.frame.origin.y - 100, width: 100, height: 50))
        newChild.treeView = self.treeView
        // Configure the tree
        treeView.tree.children[self]?.append(newChild)
        treeView.tree.children[newChild] = []
        treeView.tree.parent[newChild] = self
        // Rest of configuration
        newChild.treeView = self.treeView
        treeView.view.addSubview(newChild)
        treeView.configureArea(of: newChild)
        treeView.configureConstraints(of: newChild, withParent: self)
    }
    
    func removeNode() {
        addChildButton.removeFromSuperview()
        removeNodeButton.removeFromSuperview()
        self.removeFromSuperview()
    }
    
    func adaptChildrenConstraints() {
        
    }
}
