//
//  UnitsListViewController.swift
//  MagicMath
//
//  Created by Abhinay Simha Vangipuram on 11/2/16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit

class UnitsListViewController: UITableViewController {
    
    var unitsList = NSArray()
    var unitIcons = NSArray()
    var mathViewController = MathViewController()
    var definitionDict = NSDictionary()
    var recentConversionType = UserDefaults.standard
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: "Units List Screen")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker?.send(builder!.build() as [NSObject : AnyObject])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "MAGIC-MATH"
        self.populateTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Private methods
    func populateTableView() {
        
        if let definitionPlist = Bundle.main.path(forResource: "UnitDefinitions", ofType: "plist") {
            definitionDict = NSDictionary(contentsOfFile: definitionPlist)!
        }
        
        unitsList = ["Length", "Volume", "Weight", "Temperature", "Area"]
        unitIcons = ["length", "volume", "mass", "temperature", "area"]
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        //let footerView = UIImageView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 100))
        //footerView.image = UIImage(named: "Math-art")
        
        self.tableView.tableFooterView = self.createTableFooterView()
        
        tableView.register(UINib(nibName: "UnitDescTableViewCell", bundle: nil), forCellReuseIdentifier: "unitTypeCell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return unitsList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "unitTypeCell", for: indexPath) as! UnitDescTableViewCell

        cell.unitNameLabel.text = ((unitsList[indexPath.row] as AnyObject) as! String)
        cell.iconImage.image = UIImage(named: ((unitIcons[indexPath.row] as AnyObject) as! String))
        cell.unitDefLabel.text = (definitionDict[unitsList[indexPath.row]] as! String)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "unitSegue", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "unitSegue" ,
            let nextScene = segue.destination as? MathViewController ,
            let indexPath = self.tableView.indexPathForSelectedRow {
            let selectedUnit = unitsList[indexPath.row]
            recentConversionType.set(selectedUnit, forKey: "recentConversion")
            nextScene.unitName = selectedUnit as! String
        }
    }
    
    // MARK: Footer View
    func createTableFooterView() -> UIView {
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
        
        let versionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: footerView.frame.size.width, height: 40))

        let versionNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        
        versionLabel.textAlignment = NSTextAlignment.center
        versionLabel.font = UIFont(name: "THEROOTS", size: 16.0)
        versionLabel.textColor = UIColor.black
        versionLabel.text = String(format: "Version %@", versionNumber)
        
        footerView.addSubview(versionLabel)
        
        return footerView
    }
}
