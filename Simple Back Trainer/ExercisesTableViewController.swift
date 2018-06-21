//
//  ExercisesTableViewController.swift
//  Simple Back Trainer
//
//  Created by Ulrich Vormbrock on 21.06.18.
//  Copyright © 2018 Rookie. All rights reserved.
//

import UIKit

class ExercisesTableViewController: UITableViewController {
    
    let inactiveColor:UIColor = .lightGray


    @IBOutlet weak var buttonHandweight: UIButton!
    @IBOutlet weak var buttonBand: UIButton!
    @IBOutlet weak var buttonMat: UIButton!
    @IBOutlet weak var buttonBall: UIButton!
    @IBOutlet weak var buttonMachine: UIButton!
    
    
    @IBOutlet var buttons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buttonHandweight.tintColor = self.navigationController?.navigationBar.barTintColor
        buttonBand.tintColor = inactiveColor
        buttonMat.tintColor = inactiveColor
        buttonBall.tintColor = inactiveColor
        buttonMachine.tintColor = inactiveColor
        
        buttonHandweight.setTitle("", for: .normal)
        buttonBand.setTitle("", for: .normal)
        buttonMat.setTitle("", for: .normal)
        buttonBall.setTitle("", for: .normal)
        buttonMachine.setTitle("", for: .normal)
        
//        buttonHandweight.setTitleColor(buttonHandweight.tintColor, for: .normal)
//        buttonBand.setTitleColor(buttonBand.tintColor, for: .normal)
//        buttonMat.setTitleColor(buttonMat.tintColor, for: .normal)
//        buttonBall.setTitleColor(buttonBall.tintColor, for: .normal)
//        buttonMachine.setTitleColor(buttonMachine.tintColor, for: .normal)
//
//        buttonHandweight.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: 0.0)
//        buttonBand.titleEdgeInsets = buttonHandweight.titleEdgeInsets
//        buttonMat.titleEdgeInsets = buttonHandweight.titleEdgeInsets
//        buttonBall.titleEdgeInsets = buttonHandweight.titleEdgeInsets
//        buttonMachine.titleEdgeInsets = buttonHandweight.titleEdgeInsets
    }
    
    func clearButtons() {
    
        buttonHandweight.tintColor = inactiveColor
        buttonBand.tintColor = inactiveColor
        buttonMat.tintColor = inactiveColor
        buttonBall.tintColor = inactiveColor
        buttonMachine.tintColor = inactiveColor
    }

    
    @IBAction func filterHandweight(_ sender: Any) {
        
        clearButtons()
        buttonHandweight.tintColor = self.navigationController?.navigationBar.barTintColor
        
    }
    
    @IBAction func filterBand(_ sender: Any) {
        
        clearButtons()
        buttonBand.tintColor = self.navigationController?.navigationBar.barTintColor
    }
    
    @IBAction func filterMat(_ sender: Any) {
        
        clearButtons()
        buttonMat.tintColor = self.navigationController?.navigationBar.barTintColor
    }
    
    @IBAction func filterBall(_ sender: Any) {
        
        clearButtons()
        buttonBall.tintColor = self.navigationController?.navigationBar.barTintColor
    }
    
    @IBAction func filterMachine(_ sender: Any) {
        
        clearButtons()
        buttonMachine.tintColor = self.navigationController?.navigationBar.barTintColor
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
