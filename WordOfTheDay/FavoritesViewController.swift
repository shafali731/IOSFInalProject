//
//  FavoritesViewController.swift
//  WordOfTheDay
//
//  Created by Shafali Gupta on 5/2/22.
//

import Foundation
import UIKit


class FavoritesViewController: UITableViewController, RandomFavoriteDelegate {
    var delegate : RandomFavoriteDelegate?
    func randomButtonTapped(favWord: String) {
        let alert = UIAlertController(
            title: favWord, message: "",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Get Details", style: .default, handler: { action -> Void in self.performSegue(
            withIdentifier: "showFavoriteDetails",
            sender: favWord)}))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    @IBOutlet weak var RandButton: RandomBarButtonItem!
    var FavoritesList = [FavoritedWord]()
    let context = (UIApplication.shared.delegate as! AppDelegate) .persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        RandButton.delegate = self
        navigationItem.largeTitleDisplayMode = .never
        let darkModeEnabled = UserDefaults.standard.value(forKey: "darkModeEnabled") as? Bool
        print(darkModeEnabled!)
        if(darkModeEnabled!){
            overrideUserInterfaceStyle = .dark
        }
        else{
            overrideUserInterfaceStyle = .light
        }
        self.title = "Favorite Words"
        tableView.register(
          UITableViewCell.self,
          forCellReuseIdentifier: "FavCell")
        self.fetchFavorites()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchFavorites()
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
    }
    
    func fetchFavorites(){
        do{
            self.FavoritesList = try context.fetch(FavoritedWord.fetchRequest())
            
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }
        catch{
            print("Could not load Favorites")
        }
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return FavoritesList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavCell", for: indexPath)
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        let favoriteWords = self.FavoritesList[indexPath.row]
        cell.textLabel!.text = favoriteWords.name
        cell.textLabel!.font = UIFont(name:"American Typewriter", size:20)
        return cell
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        
        if editingStyle == .delete
           {
                context.delete(FavoritesList[indexPath.row])

               do {
                   try context.save()
                
                    FavoritesList.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
               }catch let err as NSError {
                   print("Could not delete item", err)
               }
           }
        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(tableView.indexPath)
        let word = (FavoritesList[indexPath.row]).name
        performSegue(
        withIdentifier: "showFavoriteDetails",
        sender: word)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
    if segue.identifier == "showFavoriteDetails"  {
        let controller = segue.destination as! CategoryViewController
        controller.word = sender as! String
        }
    }

}

