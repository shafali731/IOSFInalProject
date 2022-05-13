//
//  CategoryViewController.swift
//  WordOfTheDay
//
//  Created by Shafali Gupta on 4/12/22.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var FavoriteButton: UIBarButtonItem!
    var word = ""
    var wordWithoutSpaces = ""
    var dataTask: URLSessionDataTask?
    var apiResult = WordAPIResult()
    var filteredResults : [String] = []
    var filteredCategories : [String]  = []
    var filteredSyllables: [String] =  []
    var numberOfCategories = 0
    var favoritedRecipesList = [FavoritedWord]()
    override func viewDidLoad() {
        super.viewDidLoad()
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
        navigationItem.largeTitleDisplayMode = .never
        wordWithoutSpaces = word.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
        getDefinitions()
        do{
            self.favoritedRecipesList = try context.fetch(FavoritedWord.fetchRequest())
            if(self.favoritedRecipesList.contains(where: {$0.name == self.word})){
            FavoriteButton.image = UIImage(systemName: "heart.fill")
        }
        }
        catch{
            print("Could not load word")
        }
    }

    func parse(data: Data) -> WordAPIResult {
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
    
    @IBAction func favorited(){
        if FavoriteButton.image == UIImage(systemName: "heart"){
            FavoriteButton.image = UIImage(systemName: "heart.fill")
//        FavoriteButton.setImage(UIImage(systemName: "heart.fill"))
        let favorited = FavoritedWord(context: self.context)
        favorited.name = word
        do {
            try self.context.save()
            self.favoritedRecipesList = try context.fetch(FavoritedWord.fetchRequest())
            print(favorited)
        } catch { // 4
            fatalError("Error: \(error)")
          }
        }
        else if FavoriteButton.image == UIImage(systemName: "heart.fill"){
            print("double click")
            print(word)
            FavoriteButton.image = UIImage(systemName: "heart")
            for i in 0 ..< favoritedRecipesList.count{
//                print(favoritedRecipesList[i].name)
                if favoritedRecipesList[i].name == word{
                    print(i)
                    print("IN DELETE ")
                    context.delete(favoritedRecipesList[i])
                    do {
                        try self.context.save()
                    } catch { // 4
                        fatalError("Error: \(error)")
                      }
                }
            }
        }
    }

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
//        print(numberOfCategories)
//        print(filteredCategories)
//        print(filteredResults)
        cell.DetailTitle.text = filteredCategories[indexPath.row]
        cell.DetailResults.text = filteredResults[indexPath.row]
        return cell
    }
}
