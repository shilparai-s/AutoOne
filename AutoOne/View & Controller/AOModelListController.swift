//
//  AOModelListController.swift
//  AutoOne
//
//  Created by Shilpa S on 18/11/19.
//  Copyright © 2019 Shilpa S. All rights reserved.
//

import UIKit

class AOModelListController: AOBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyContentView: UIView!
    
    @IBOutlet weak var messageLabel: UILabel!
    var manufacturer : AOManufacturer?
    var page : Int = 1
    var pageSize : Int = 10
    var models  = [AOModel]()
    
    private var draggingOffset : CGPoint = .zero

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Models"
        configureTableView()
        self.showActivityIndicator()
        loadModels()
    }
    
    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 60.0
        self.tableView.register(UINib(nibName: "AOModelCell", bundle: nil), forCellReuseIdentifier: CellIdentifer.models.rawValue)
    }
    
    private func loadModels() {
        
        if self.page > 0 {
            self.tableView.isUserInteractionEnabled = false
            if let manufacturer = self.manufacturer {
            
                AONetworkService.startService(with: AONetworkRouter.shared.modelRequest(for: manufacturer.id, page:self.page , pageSize: self.pageSize), onCompletion: {
                    (response,error) in
                    self.hideActivityIndicator()
                    if let response = response, let list = response["wkda"] as? [String : String] {
                        if list.count < self.pageSize {
                            self.page = self.page + 1
                        }
                        else {
                            self.page = 0
                        }
                        self.refresh(with: list)
                    }
                    else if let error = error {
                        //Show alert here
                        let alertVC = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
                            _ in
                            alertVC.dismiss(animated: true, completion: nil)
                        })
                        alertVC.addAction(okAction)
                        self.present(alertVC, animated: true, completion: nil)
                    }
                })

            }
        }
    }
    
    private func refresh(with list : [String : String]) {
        for item in list.sorted(by: {$0.key < $1.key }) {
            let model = AOModel(name: item.key, key: item.value)
            self.models.append(model)
        }
        if self.models.isEmpty {
            self.tableView.isHidden = true
            self.emptyContentView.isHidden = false
            self.messageLabel.text = "Sorry, No models available for " + "\(manufacturer!.name)"
        }
        else {
            self.tableView.isHidden = false
            self.emptyContentView.isHidden = true
            self.tableView.reloadData()
            self.tableView.isUserInteractionEnabled = true
        }
    }
}

extension AOModelListController : UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifer.models.rawValue, for: indexPath) as! AOModelCell
        cell.nameLabel.text = self.models[indexPath.row].name
        
        let color1 = UIColor(red: 74.0/255.0, green: 141.0/255.0, blue: 214.0/255.0, alpha: 0.3)
        let color2 =  UIColor(red: 74.0/255.0, green: 141.0/255.0, blue: 214.0/255.0, alpha: 0.1)
         
         if (indexPath.row % 2) == 0 {
             cell.backgroundColor = color1
         }
         else {
             cell.backgroundColor = color2

         }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let model = self.models[indexPath.row]
        let alertVC = UIAlertController(title: nil, message: "You have selected \(model.name) car from \(manufacturer!.name)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            _ in
            alertVC.dismiss(animated: true, completion: nil)
        })
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    
    //Refresh on Scroll down
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
         
         let endOffset = scrollView.contentOffset
         
         if draggingOffset.y < endOffset.y {
             if let lastIndexPath = tableView.indexPathsForVisibleRows?.last {
                 if lastIndexPath.row >= (self.models.count / 2) {
                     self.loadModels()
                 }
             }
         }
         
     }
         
     func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
         
         draggingOffset = scrollView.contentOffset
     }
     


}
