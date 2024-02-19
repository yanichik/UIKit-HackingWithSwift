//
//  ViewController.swift
//  GuessTheFlag
//
//  Created by YB on 1/17/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var questionsAsked = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
//        button3.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor(red: 1, green: 0.6, blue: 0.3, alpha: 0.5).cgColor
        button3.layer.borderWidth = 3
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        // show score in title when tapping - action viewed as a share button
        // navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showScoreTapped))
        
        // show score in title when tapping - viewed as text
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score", style: .plain, target: self, action: #selector(showScoreTapped))
        
        askQuestion(action: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func askQuestion(action: UIAlertAction!) {
        questionsAsked += 1
        countries.shuffle()
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        correctAnswer = Int.random(in: 0...2)
        
        // uppercased() capitalized UK & US properly
        // title with score
        // title = "\(countries[correctAnswer].uppercased()), Score: \(score)"
        // title without score
        title = "\(countries[correctAnswer].uppercased())"
        // localizedCapitalized capitalized Uk & Us improperly
//        title = countries[correctAnswer].localizedCapitalized
    }
    @IBAction func buttonTapped(_ sender: UIButton) {
        if (sender.tag == correctAnswer){
            title = "Correct!"
            score += 1
        } else {
            title = "Wrong! That's the flag of \(countries[sender.tag].uppercased())."
            score -= 1
        }
        if questionsAsked < 10 {
            // no message
//            let ac = UIAlertController(title: title, message: "", preferredStyle: .alert)
            
            // show score in title
             let ac = UIAlertController(title: title, message: "Your score is \(score).", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(ac, animated: true)
        } else {
            questionsAsked = 0
            score = 0
            let ac = UIAlertController(title: title, message: "Final score is \(score).", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Start New Game", style: .default, handler: askQuestion))
            present(ac, animated: true)
        }
    }
    
    @objc func showScoreTapped(){
        print("show score tapped")
        title = "\(countries[correctAnswer].uppercased()), Score: \(score)"
    }
    
    
}

