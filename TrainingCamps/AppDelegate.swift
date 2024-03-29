//
//  AppDelegate.swift
//  TrainingCamps
//
//  Created by Steven Lord on 05/06/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    //may shift these to a contants class
    static var edtPink: NSColor = NSColor(red: 229.0 / 256.0, green: 42.0 / 256.0, blue: 119.0 / 256.0, alpha: 1.0)
    static var edtBlue: NSColor = NSColor(calibratedRed: 26.0 / 256.0, green: 120.0 / 256.0, blue: 184.0 / 256.0, alpha: 1.0)
//    static var edtBlue: NSColor = NSColor(red: 26.0, green: 120.0, blue: 184.0, alpha: 1.0)


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application

        //set up default colours for different disciplines
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: NSColor.blue) as NSData?, forKey: UserDefaultKey.swimColour.rawValue)
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: NSColor.brown) as NSData?, forKey: UserDefaultKey.bikeColour.rawValue)
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: NSColor.red) as NSData?, forKey: UserDefaultKey.runColour.rawValue)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }



    // MARK: - Core Data Saving and Undo support

    @IBAction func saveAction(_ sender: AnyObject?) {
        // Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
        let context = CoreDataStack.shared.trainingCampsPC.viewContext

        if !context.commitEditing() {
            NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing before saving")
        }
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Customize this code block to include application-specific recovery steps.
                let nserror = error as NSError
                NSApplication.shared.presentError(nserror)
            }
        }
    }

    func windowWillReturnUndoManager(window: NSWindow) -> UndoManager? {
        // Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
        return CoreDataStack.shared.trainingCampsPC.viewContext.undoManager
    }

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        // Save changes in the application's managed object context before the application terminates.
        let context = CoreDataStack.shared.trainingCampsPC.viewContext
        
        if !context.commitEditing() {
            NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing to terminate")
            return .terminateCancel
        }
        
        if !context.hasChanges {
            return .terminateNow
        }
        
        do {
            try context.save()
        } catch {
            let nserror = error as NSError

            // Customize this code block to include application-specific recovery steps.
            let result = sender.presentError(nserror)
            if (result) {
                return .terminateCancel
            }
            
            let question = NSLocalizedString("Could not save changes while quitting. Quit anyway?", comment: "Quit without saves error question message")
            let info = NSLocalizedString("Quitting now will lose any changes you have made since the last successful save", comment: "Quit without saves error question info");
            let quitButton = NSLocalizedString("Quit anyway", comment: "Quit anyway button title")
            let cancelButton = NSLocalizedString("Cancel", comment: "Cancel button title")
            let alert = NSAlert()
            alert.messageText = question
            alert.informativeText = info
            alert.addButton(withTitle: quitButton)
            alert.addButton(withTitle: cancelButton)
            
            let answer = alert.runModal()
            if answer == .alertSecondButtonReturn {
                return .terminateCancel
            }
        }
        // If we got here, it is time to quit.
        return .terminateNow
    }

}

