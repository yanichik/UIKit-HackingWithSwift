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
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareAppTapped))
        title = "Storm Viewer"
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
        pictures.sort()
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = "Picture \(indexPath.row + 1) of \(pictures.count)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailedVC = self.storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController{
            detailedVC.selectedImage = pictures[indexPath.row]
            navigationController?.pushViewController(detailedVC, animated: true)
        }
    }
    
    @objc func shareAppTapped(){
        print("share app tapped")
        let appURL = URL(string: "https://www.stormviewer.com")
        // create vc, present vc
        let vc = UIActivityViewController(activityItems: ["I highly recommend this Storm Viewer App!", appURL], applicationActivities: nil)
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}

