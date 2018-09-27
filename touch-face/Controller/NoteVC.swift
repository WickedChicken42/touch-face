//
//  ViewController.swift
//  touch-face
//
//  Created by James Ullom on 9/26/18.
//  Copyright © 2018 Hammer of the Gods Software. All rights reserved.
//

import UIKit
import LocalAuthentication

class NoteVC: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var addNote: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        tableView.delegate = self
        tableView.dataSource = self

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    func authenticateBiometrics(completion: @escaping (Bool) -> Void) {
        
        // Instanciates the Local Auth context
        let myContext = LAContext()
        let myLocalizedReasonString = "Our app uses Touch/Face ID to secure your notes."
        var authError: NSError?
        
        if #available(iOS 8.0, macOS 10.12.1, *) {
            if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                // NEED TO ADD: The following key into the info.plist for the app:
                // NSFaceIDUsageDescription with the same text as the myLocalizedReasonString
                myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString) { [unowned self] (success, evaluateError) in
                        if success {
                            completion(true)
                        } else {
                            DispatchQueue.main.async {
                                guard let evalErrorString = evaluateError?.localizedDescription else { return }
                                // present an alter
                                self.showAlert(withMessage: evalErrorString)
                                completion(false)
                            }
                        }
                }
            } else {
                guard let authErrorString = authError?.localizedDescription else { return }
                self.showAlert(withMessage: authErrorString)
                completion(false)
            }
            
        } else {
            completion(false)
        }
        
    }
    
    func showAlert(withMessage message: String) {
        
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func addNotePressed(_ sender: Any) {
        
        let newNote = Note(message: "", lockStatus: .unlocked)
        notesArray.append(newNote)
        pushNoteFor(indexPath: IndexPath(row: notesArray.count - 1, section: 0))

    }
    
}

extension NoteVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as? NoteCell else { return UITableViewCell() }
        
        let note = notesArray[indexPath.row]
        cell.configureCell(note: note)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // pass note and present VC
        if notesArray[indexPath.row].lockStatus == .locked {
            // perform the biometrics check
            authenticateBiometrics(completion: { (authenticated) in
                if authenticated {
                    notesArray[indexPath.row].flipLockStatus()
                    // Needed to call this Dispatch because the auth work happenes on a background thread but we need to push our VC on the main thread
                    DispatchQueue.main.async {
                        self.pushNoteFor(indexPath: indexPath)
                    }
                    
                }
            })
        } else {
            pushNoteFor(indexPath: indexPath)
        }
    }
    
    func pushNoteFor(indexPath: IndexPath) {
        
        guard let noteDetailVC = storyboard?.instantiateViewController(withIdentifier: "NoteDetailVC") as? NoteDetailVC else { return }
        
        noteDetailVC.currentNote = notesArray[indexPath.row]
        noteDetailVC.index = indexPath.row
        navigationController?.pushViewController(noteDetailVC, animated: true)
        
    }
    
}
