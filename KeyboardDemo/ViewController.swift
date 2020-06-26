//
//  ViewController.swift
//  KeyboardDemo
//
//  Created by Walter Fettich on 23/06/2020.
//  Copyright © 2020 Walter Fettich. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    let keyboardHelper = KeyboardHelper()

    @IBOutlet weak var content: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func addKeyboardHelper()
    {
        keyboardHelper.debugMode = false
        keyboardHelper.contentView = content        
                
        keyboardHelper.registerForKeyboardNotifications()
        
        keyboardHelper.onKeyboardWillBeShown =
        {
            keyboardRect in
            
        }
        
        keyboardHelper.onKeyboardWillBeResized =
        {
            keyboardRect in
            
        }
        
        keyboardHelper.onKeyboardWillBeHidden =
        {
            keyboardRect in
        }
    }
    
    @IBAction func pressedAddKeyboardHelper(_ sender: UIButton)
    {
        addKeyboardHelper()
        sender.removeFromSuperview()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1)
        {
            nextField.becomeFirstResponder()
            keyboardHelper.scrollIfNeeded()
        }
        else
        {
            textField.resignFirstResponder()
        }
        
        return true
    }
}

