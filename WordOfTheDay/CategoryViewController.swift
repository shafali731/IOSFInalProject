//
//  CategoryViewController.swift
//  WordOfTheDay
//
//  Created by Shafali Gupta on 4/12/22.
//

import UIKit

class CategoryViewController: UITableViewController {
//    var categoryList = ["Definition"]
    var word = ""
    var wordWithoutSpaces = ""
    var dataTask: URLSessionDataTask?
    var apiResult = WordAPIResult()
    var filteredResults : [String] = []
    var filteredCategories : [String]  = []
    var filteredSyllables: [String] =  []
    var numberOfCategories = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        wordWithoutSpaces = word.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
        getDefinitions()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
//    {
//        if segue.destination is AllResultsViewController {
//            let vc = segue.destination as? AllResultsViewController
//            vc?.word = self.word
//            getDefinitions()
////            if segue.identifier == "getDefinition" {
////                print("hefejofije")
////                vc?.title = "Definition"
////                getDefinitions()
////                vc?.wordsApiResult = self.apiResult
////            }
//
//        }
//    }
    func parse(data: Data) -> WordAPIResult {
//        print(data)
      do {
        let decoder = JSONDecoder()
        let result = try decoder.decode(
            WordAPIResult.self, from: data)
                return result
      } catch {
        print("JSON Error: \(error)")
        return WordAPIResult()
      }
    }
    func getDefinitions(){
        let session = URLSession.shared
        let headers = [
            "X-RapidAPI-Host": "wordsapiv1.p.rapidapi.com",
            "X-RapidAPI-Key": "9483f26ecemshf49e067ed59a85ep13913bjsn0692add47693"
        ]
        let url = URL(string: "https://wordsapiv1.p.rapidapi.com/words/\(wordWithoutSpaces)")!
        print(url)
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        dataTask = session.dataTask(with: request) {data, response, error in
          if let error = error as NSError?, error.code == -999 {
            return  // Search was cancelled
          } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            if let data = data {
                  
                self.apiResult = self.parse(data: data)
                if let result = self.apiResult.results{
                    if result[0].definition != nil{
                        self.filteredCategories.append("DEFINITION")
                        self.filteredResults.append(self.apiResult.results![0].definition!)
                    }
                    if result[0].partOfSpeech != nil{
                        self.filteredCategories.append("PART OF SPEECH")
                        self.filteredResults.append(self.apiResult.results![0].partOfSpeech!)
                    }
                    if result[0].synonyms != nil{
                        self.filteredCategories.append("SYNONYMS")
                        self.filteredResults.append(self.apiResult.results![0].synonyms!.joined(separator: ", "))
                    }
                    if result[0].typeOf != nil{
                        self.filteredCategories.append("TYPE OF")
                        self.filteredResults.append(self.apiResult.results![0].typeOf!.joined(separator: ", "))
                    }
                    if result[0].hasTypes != nil{
                        self.filteredCategories.append("HAS TYPES")
                        self.filteredResults.append(self.apiResult.results![0].hasTypes!.joined(separator: ", "))
                    }
                    if result[0].derivation != nil{
                        self.filteredCategories.append("DERIVATION")
                        self.filteredResults.append(self.apiResult.results![0].derivation!.joined(separator: ", "))
                    }
                    if result[0].examples != nil{
                        self.filteredCategories.append("EXAMPLES")
                        self.filteredResults.append(self.apiResult.results![0].examples!.joined(separator: ", "))
                    }
                }
                if let syllablesList = self.apiResult.syllables{
                    if syllablesList.list != nil{
                        self.filteredCategories.append("SYLLABLES")
//                        self.filteredSyllables.append(contentsOf: syllablesList.list!)
                        self.filteredResults.append(syllablesList.list!.joined(separator: ", "))

//                        self.numberOfCategories += 1
                    }
                }
                for val in self.filteredResults{
                    print(val)
                }
                for val in self.filteredSyllables{
                    print(val)
                }
                for val in self.filteredCategories{
                    print(val)
                }
                print(self.apiResult)
                self.numberOfCategories += self.filteredCategories.count
                if(self.numberOfCategories == 0){
                    self.filteredCategories.append("Sorry!")
                    self.filteredResults.append("There is currently no information on this word")
                    self.numberOfCategories = 1
                }
//                self.delegate?.ViewControllerGetWord(self,self.randomWordResult)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.title = self.word.uppercased()
                    self.tableView.reloadData()
//                    self.wordLabel.text = self.randomWordResult
//                    self.infoButton.isHidden = false
//                    self.playSoundEffect()
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
//    // MARK: - Navigation
//    override func prepare(
//      for segue: UIStoryboardSegue,
//      sender: Any?
//    ){// 1
//        if segue.identifier == "getWordCategory" {
//          // 2
//          let controller = segue.destination as! ViewController
//          // 3
//          controller.delegate = self
//      } }
//    // MARK: -ViewController Delegates
//    func ViewControllerGetWord(
//        _ controller: ViewController,
//        _ word: String
//    ){
//        self.word = word
//        print(self.word)
//    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return numberOfCategories
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cellIdentifier = "Category"
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category", for: indexPath) as! DetailsTableViewCell
//        print(categoryList)
        print(numberOfCategories)
        print(filteredCategories)
        print(filteredResults)
//        if(numberOfCategories == 0){
//            cell.DetailTitle.text = "Sorry!"
//            cell.DetailResults.text = "There is currently no information on this word"
//        }
//        else{
        cell.DetailTitle.text = filteredCategories[indexPath.row]
        cell.DetailResults.text = filteredResults[indexPath.row]
//        }
//        let label = cell.viewWithTag(1000) as! UILabel
//                  label.text = filteredCategories[indexPath.row]
//        let secondLabel = cell.viewWithTag(1001)as! UILabel
//        secondLabel.text = String(describing:filteredResults[indexPath.row])
//
//        let item = filteredCategories[indexPath.row]       // Add this
//        print(item)
//        let label = cell.viewWithTag(1000) as! UILabel
//          label.text = item
//        print(label.text)
        // Configure the cell...

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}