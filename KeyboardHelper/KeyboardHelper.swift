//
//  KeyboardHelper.swift
//  TravelLive
//
//  Created by Walter Fettich on 18/12/2018.
//  Copyright © 2018 Walter Fettich. All rights reserved.
//

import UIKit

class KeyboardHelper: NSObject
{
    let scrollView = UIScrollView()
    
    var contentView:UIView?
    {
        didSet
        {
            guard contentView != nil else {return}
            scrollView.backgroundColor = .red
            
            contentView!.removeOuterConstraints()
            contentView!.superview?.set(contentView:scrollView)
            
            scrollView.set(content: contentView!)
        }
    }
        
    var onKeyboardWillBeShown:((CGRect)->())?
    
    var onKeyboardDidShow:((CGRect)->())?
    
    var onKeyboardWillBeResized:((CGRect)->())?
    
    var onKeyboardWillBeHidden:((CGRect)->())?
    
    func registerForKeyboardNotifications()
    {
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasResized(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    // MARK:- Keyboard hide/show methods
    var isKeyboardShown = false
    
    var movedOffset:CGFloat = 0
    
    @objc func keyboardWillShow(_ notification: Notification)
    {
        if let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        {
            
            if(false == isKeyboardShown)
            {
                isKeyboardShown = true
                                
                if let firstResponder = contentView?.window?.firstResponder
                {
                    // do something with `firstResponder`
                    
                    if let absRect = firstResponder.superview?.convert(firstResponder.frame, to:nil),
                    absRect.maxY > keyboardRect.origin.y
                    {
                        movedOffset = keyboardRect.size.height
                        let y = scrollView.contentOffset.y + movedOffset
                        let x = scrollView.contentOffset.x
                        scrollView.contentOffset = CGPoint(x: x,y: y)
                    }
                }
                
                onKeyboardWillBeShown?(keyboardRect)
            }
        }
    }
    
    @objc func keyboardDidShow(_ notification: Notification)
    {
        if let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            if(isKeyboardShown)
            {                
                onKeyboardDidShow?(keyboardRect)                
            }
        }
    }
    
    @objc func keyboardWasResized(_ notification: Notification)
    {
        if let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            if(isKeyboardShown)
            {
                onKeyboardWillBeResized?(keyboardRect)
                
            }
        }
    }
    
    @objc func keyboardWillBeHidden(_ notification: Notification)
    {
        if let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if(isKeyboardShown)
            {
                onKeyboardWillBeHidden?(keyboardRect)
                
                let y = scrollView.contentOffset.y - movedOffset
                let x = scrollView.contentOffset.x
                scrollView.contentOffset = CGPoint(x: x,y: y)
                
                isKeyboardShown = false
                movedOffset = 0
            }
        }
    }
}

extension UIView
{
    func set(contentView: UIView)
    {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentView)
        
        let containerViewLeadingConstraint = NSLayoutConstraint(item: contentView, attribute: .leading, relatedBy: .equal
            , toItem: contentView.superview, attribute:.leading, multiplier: 1, constant: 0)
        
        let containerViewTopConstraint = NSLayoutConstraint(item: contentView, attribute: .top, relatedBy: .equal
            , toItem: contentView.superview, attribute: .top, multiplier: 1, constant: 0)
        
        let containerViewBottomConstraint = NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal
            , toItem: contentView.superview, attribute: .bottom, multiplier: 1, constant: 0)
        
        let containerViewEndConstraint = NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal
            , toItem: contentView.superview, attribute: .trailing, multiplier: 1, constant: 0)
                
        NSLayoutConstraint.activate([
            containerViewLeadingConstraint
            ,containerViewTopConstraint
            ,containerViewBottomConstraint
            ,containerViewEndConstraint
            ])
        
        setNeedsUpdateConstraints()
        setNeedsLayout()
    }
}

extension UIScrollView
{
    func set(content:UIView)
    {
        content.translatesAutoresizingMaskIntoConstraints = false
                    
        addSubview(content)
        
        NSLayoutConstraint.activate([
        frameLayoutGuide.widthAnchor.constraint(equalTo: content.widthAnchor),
        
        contentLayoutGuide.leadingAnchor.constraint(equalTo: content.leadingAnchor),
        contentLayoutGuide.topAnchor.constraint(equalTo: content.topAnchor),
        contentLayoutGuide.trailingAnchor.constraint(equalTo: content.trailingAnchor),
        contentLayoutGuide.bottomAnchor.constraint(equalTo: content.bottomAnchor),
        ])
    }
}


extension UIView {
    var firstResponder: UIView? {
        guard !isFirstResponder else { return self }

        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }

        return nil
    }
}


extension UIView {
    
    public func removeOuterConstraints()
    {
        if let superview = self.superview
        {
            for constraint in superview.constraints {
                
                if let first = constraint.firstItem as? UIView, first == self {
                    superview.removeConstraint(constraint)
                }
                
                if let second = constraint.secondItem as? UIView, second == self {
                    superview.removeConstraint(constraint)
                }
            }
        }
                            
        self.translatesAutoresizingMaskIntoConstraints = true
    }
    
    
    public func removeAllConstraints() {
        var _superview = self.superview
        
        while let superview = _superview {
            for constraint in superview.constraints {
                
                if let first = constraint.firstItem as? UIView, first == self {
                    superview.removeConstraint(constraint)
                }
                
                if let second = constraint.secondItem as? UIView, second == self {
                    superview.removeConstraint(constraint)
                }
            }
            
            _superview = superview.superview
        }
        
        self.removeConstraints(self.constraints)
        self.translatesAutoresizingMaskIntoConstraints = true
    }
}
