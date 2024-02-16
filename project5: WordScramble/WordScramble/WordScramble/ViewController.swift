//
//  ViewController.swift
//  WordScramble
//
//  Created by YB on 2/15/24.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = self.editButtonItem
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startWords = try? String(contentsOf: startWordsURL){
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        startGame()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }

    func startGame(){
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    @objc func promptForAnswer(){
        let alertController = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {[weak self, weak alertController] submitAction in
            guard let answer = alertController?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        alertController.addAction(submitAction)
        present(alertController, animated: true)
    }
    
    func submit(_ answer: String){
        let errorTitle: String
        let errorMsg: String

        // Perform 3 checks: submission is in English, hasn't been used already, and can actually be constructed from given word
        // Then pass this answer to usedWords array
        let loweredAnswer = answer.lowercased()
        if isPossible(loweredAnswer) {
            if isReal(loweredAnswer) {
                if isNew(loweredAnswer) {
                    usedWords.insert(loweredAnswer, at: 0)
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    return
                } else {
                    errorTitle = "Repetitive!"
                    errorMsg = "This answer has previously been submitted. Try another response."
                }
            } else {
                errorTitle = "Not A Word!"
                errorMsg = "This answer is not in the English Dictionary. Try again."
            }
        } else {
            guard let title = title else { return }
            errorTitle = "Not Possible!"
            errorMsg = "This word is not possible to spell from \(title)"
        }
        let alertController = UIAlertController(title: errorTitle, message: errorMsg, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok.", style: .default))
        present(alertController, animated: true)
    }
    
    // if can be constructed from given word
    func isPossible(_ word: String) -> Bool {
        guard var tmpTitle = title?.lowercased() else { return false }
        for letter in word {
            if let firstInd = tmpTitle.firstIndex(of: letter) {
                tmpTitle.remove(at: firstInd)
            } else {
                return false
            }
        }
        return true
    }
    
    // if is new
    func isNew(_ word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    // if actual English word
    func isReal(_ word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.count)
        let mispelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return mispelledRange.location == NSNotFound
    }
}

