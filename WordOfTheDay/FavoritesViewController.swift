//
//  FavoritesViewController.swift
//  WordOfTheDay
//
//  Created by Shafali Gupta on 5/2/22.
//

import Foundation
import UIKit

//protocol RandomFavoriteDelegate: AnyObject{
////    func randomButtonTapped(name:String, button: UIButton, id: Int)
//    func randomButtonTapped()
//}
//class RandomBarButtonItem : UIBarButtonItem {
//    weak var delegate: RandomFavoriteDelegate?
//    override init()     {
////        print("uyhu")
//        super.init()
////        target = self
////        action = #selector(tapped)
//    }
//
//    required init?(coder aDecoder:NSCoder) {
//        super.init(coder: aDecoder)
//    }
//    override func awakeFromNib() {
//            self.action = #selector(RandomBarButtonItem.didTapButton)
//        }
//
//    @objc func didTapButton() {
//        print("efefh")
//        delegate?.randomButtonTapped()
//    }
//}

class FavoritesViewController: UITableViewController, RandomFavoriteDelegate {
    var delegate : RandomFavoriteDelegate?
    func randomButtonTapped(favWord: String) {
        let alert = UIAlertController(
            title: "Random Favorite",
            message: favWord,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Get Details", style: .cancel, handler: { action -> Void in self.performSegue(
            withIdentifier: "showFavoriteDetails",
            sender: favWord)}))
        present(alert, animated: true)
    }
    
    @IBOutlet weak var RandButton: RandomBarButtonItem!
    var FavoritesList = [FavoritedWord]()
    let context = (UIApplication.shared.delegate as! AppDelegate) .persistentContainer.viewContext
//    let barButton = RandomBarButtonItem()
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
//        self.navigationItem.setLeftBarButton(barButton, animated: true)
        tableView.register(
          UITableViewCell.self,
          forCellReuseIdentifier: "FavCell")
        self.fetchFavorites()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
//    // MARK: - Navigation
//    override func prepare(
//      for segue: UIStoryboardSegue,
//      sender: Any?
//    ){// 1
//        if segue.identifier == "getWordResults" {
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

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return FavoritesList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavCell", for: indexPath)
//        as! FavoritesTableViewCell
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        let favoriteWords = self.FavoritesList[indexPath.row]
        cell.textLabel!.text = favoriteWords.name
        cell.textLabel!.font = UIFont(name:"American Typewriter", size:20)
//        cell.FavTitle.text = favoriteWords.name
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
//    override func tableView(
//      _ tableView: UITableView,
//      accessoryButtonTappedForRowWith indexPath: IndexPath
//    ){
//        print("hello")
//    let controller = storyboard!.instantiateViewController(
//        withIdentifier: "CategoryViewController") as!
//    CategoryViewController
////      controller.delegate = self
//        let word = (FavoritesList[indexPath.row]).name!
//        controller.word = word
////      controller.checklistToEdit = checklist
//      navigationController?.pushViewController(
//        controller,
//        animated: true)
//    }
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

//extension FavoritesViewController: RandomFavoriteDelegate{
//    delegate = self
//    func randomButtonTapped() {
//        print("EHFIUHFUEHIUFH")
//        let alert = UIAlertController(
//            title: "Random Favorite",
//            message: "here you go",
//            preferredStyle: .alert
//        )
//        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
//        present(alert, animated: true)
//    }
//}

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
