//
//  ViewController.swift
//  WordOfTheDay
//
//  Created by Shafali Gupta on 4/7/22.
//

import UIKit
import AudioToolbox
import CoreData

let applicationDocumentsDirectory: URL = {
  let paths = FileManager.default.urls(
    for: .documentDirectory,
    in: .userDomainMask)
  return paths[0]
}()

protocol ViewControllerDelegate: AnyObject {
  func ViewControllerGetWord(
    _ controller: ViewController,
    _ word: String)
}

class ViewController: UIViewController {
    weak var delegate: ViewControllerDelegate?
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var darkModeSwitch: UISwitch!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var darkModeLabel: UILabel!
    var soundID: SystemSoundID = 0
    var dataTask: URLSessionDataTask?
    var randomWordResult = ""
    var foundWord = false
    let defaults = UserDefaults.standard
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
    if segue.destination is CategoryViewController {
    let vc = segue.destination as? CategoryViewController
        vc?.word = self.randomWordResult
//        vc?.managedObjectContext = managedObjectContext
    }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        wordLabel.text = ""
        UIView.animate(withDuration: 2.0, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {
            self.titleLabel.center = CGPoint(x:0, y:0 + 25)
        }, completion: nil)
        infoButton.isHidden = true
        loadSoundEffect("Sound.caf")
        defaults.set(false, forKey: "darkModeEnabled")
        darkModeLabel.text = "Dark Mode"
        let darkModeEnabled = UserDefaults.standard.value(forKey: "darkModeEnabled") as? Bool
        print(darkModeEnabled!)
        if(darkModeEnabled!){
            overrideUserInterfaceStyle = .dark
            self.navigationController!.navigationBar.barStyle = .black
            self.navigationController!.navigationBar.isTranslucent = false
            self.navigationController!.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        }
        else{
            overrideUserInterfaceStyle = .light
            self.navigationController!.navigationBar.barStyle = .default
            self.navigationController!.navigationBar.isTranslucent = true
            self.navigationController!.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        }
        
//        overrideUserInterfaceStyle = .dark
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let darkModeEnabled = UserDefaults.standard.value(forKey: "darkModeEnabled") as? Bool
        if(darkModeEnabled!){
            overrideUserInterfaceStyle = .dark
            self.navigationController!.navigationBar.barStyle = .black
            self.navigationController!.navigationBar.isTranslucent = false
            self.navigationController!.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]

        }
        else{
            overrideUserInterfaceStyle = .light
            self.navigationController!.navigationBar.barStyle = .default
            self.navigationController!.navigationBar.isTranslucent = true
            self.navigationController!.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        }
    }
    
    @IBAction func switchDidChange(_ sender: UISwitch){
        print("clicked")
        if darkModeSwitch.isOn{
            defaults.set(true, forKey: "darkModeEnabled")
            overrideUserInterfaceStyle = .dark
        }
        else{
            defaults.set(false, forKey: "darkModeEnabled")
            overrideUserInterfaceStyle = .light
            self.navigationController!.navigationBar.barStyle = .default
            self.navigationController!.navigationBar.isTranslucent = true
            self.navigationController!.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        }
//        print(defaults.value(forKey: "darkModeEnabled"))
    }
    @IBAction func randomWord(_ sender: Any) {
            getRandomWord()
    }
    func parse(data: Data) -> String {
//        print(data)
      do {
        let decoder = JSONDecoder()
        let result = try decoder.decode(
          RandomResult.self, from: data)
//          print(result)
          return result.word!
      } catch {
        print("JSON Error: \(error)")
        return ""
      }
    }
    func getRandomWord() {
        randomWordResult = ""
        let session = URLSession.shared
        let headers = [
            "X-RapidAPI-Host": "wordsapiv1.p.rapidapi.com",
            "X-RapidAPI-Key": "9483f26ecemshf49e067ed59a85ep13913bjsn0692add47693"
        ]
        let url = URL(string: "https://wordsapiv1.p.rapidapi.com/words/?random=true")!
//    https://random-word-api.herokuapp.com/word
//        let url = URL(string: "https://random-word-api.herokuapp.com/word")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10.0)
//        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        dataTask = session.dataTask(with: request) {data, response, error in
          if let error = error as NSError?, error.code == -999 {
            return  // Search was cancelled
          } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            if let data = data {
                self.randomWordResult = self.parse(data: data)
                print(self.randomWordResult)
                self.delegate?.ViewControllerGetWord(self,self.randomWordResult)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.wordLabel.text = self.randomWordResult
//                    UIView.animate(withDuration: 2.0, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, options: [], animations: {
//                        self.wordLabel.center = CGPoint(x:20, y:350 + 15)
//                    }, completion: nil)
                    self.infoButton.isHidden = false
                    self.playSoundEffect()
                }
                return
            }
          } else {
            print("Failure! \(response!)")
              return
          }
        }
        dataTask?.resume()
    }
    
    // MARK: - Sound effects
    func loadSoundEffect(_ name: String) {
      if let path = Bundle.main.path(forResource: name, ofType: nil)
    {
        let fileURL = URL(fileURLWithPath: path, isDirectory: false)
        let error = AudioServicesCreateSystemSoundID(fileURL as
    CFURL, &soundID)
        if error != kAudioServicesNoError {
          print("Error code \(error) loading sound: \(path)")
        }
    } }
    func unloadSoundEffect() {
      AudioServicesDisposeSystemSoundID(soundID)
    soundID = 0 }
    func playSoundEffect() {
      AudioServicesPlaySystemSound(soundID)
    }

}

