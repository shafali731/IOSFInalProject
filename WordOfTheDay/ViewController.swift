//
//  ViewController.swift
//  WordOfTheDay
//
//  Created by Shafali Gupta on 4/7/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var randButton: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        wordLabel.text = ""
        infoButton.isHidden = true
        randButton.text = ""
    }

    @IBAction func randomWord(_ sender: Any) {
        let array = ["hello", "bye", "word", "tester"]
        wordLabel.text = array.randomElement()
        infoButton.isHidden = false
    }
    @IBAction func getInfo(_ sender: Any) {
        randButton.text = "hi"
    }
}

