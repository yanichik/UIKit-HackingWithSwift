//
//  ViewController.swift
//  StormViewer
//
//  Created by YB on 1/9/24.

// iOS user interface toolkit
import UIKit

// When you see a data type that starts with “UI”, it means it comes from UIKit.
// UIViewController is Apple’s default screen type, which is empty and white until we change it.
class ViewController: UITableViewController {
    // will be created when the ViewController screen is created, and exist for as long as the screen exists. It will be empty, because we haven’t actually filled it with anything, but at least it’s there ready for us to fill.
    var pictures = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // shared file manager object. data type that lets us work with the filesystem, and in our case we'll be using it to look for files.
        let fm = FileManager.default
        // set to the resource path of our app's bundle. bundle is a directory containing our compiled program and all our assets. So, this line says, "tell me where I can find all those images I added to my app."
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl"){
                pictures.append(item)
            }
        }
        print(pictures)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
}

