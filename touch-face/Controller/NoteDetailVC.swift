//
//  NoteDetailVC.swift
//  touch-face
//
//  Created by James Ullom on 9/26/18.
//  Copyright © 2018 Hammer of the Gods Software. All rights reserved.
//

import UIKit

class NoteDetailVC: UIViewController {

    @IBOutlet var noteTextView: UITextView!
    
    var currentNote: Note!
    var index: Int!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        noteTextView.text = currentNote.message
    }
    
    @IBAction func lockButtonPressed(_ sender: Any) {
    
        currentNote.flipLockStatus()
        navigationController?.popViewController(animated: true)
    }
    
}
