//
//  Note.swift
//  touch-face
//
//  Created by James Ullom on 9/26/18.
//  Copyright © 2018 Hammer of the Gods Software. All rights reserved.
//

import Foundation

class Note {
    
    public private(set) var message: String
    public private(set) var lockStatus: LockStatus

    init(message: String, lockStatus: LockStatus) {
        
        self.message = message
        self.lockStatus = lockStatus
        
    }

    func setLockStatus(isLocked: Bool) {
        if isLocked { lockStatus = .locked } else { lockStatus = .unlocked }
    }
    
}
