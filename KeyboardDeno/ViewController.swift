//
//  ViewController.swift
//  KeyboardDeno
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
        
        addKeyboardHandler()
    }
    
    func addKeyboardHandler()
    {
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
    }
}

