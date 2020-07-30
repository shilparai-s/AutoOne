//
//  AOManufacturerListController.swift
//  AutoOne
//
//  Created by Shilpa S on 18/11/19.
//  Copyright © 2019 Shilpa S. All rights reserved.
//

import UIKit


class AOManufacturerListController: AOBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var page : Int = 1
    let pageSize : Int = 15
    /// Array property to store manufacture list
    var manufacturerList = [AOManufacturer]()
    
    private var draggingOffset : CGPoint = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 74.0/255.0, green: 141.0/255.0, blue: 214.0/255.0, alpha: 1.0)
        self.title = "Manufacturer"
        configureTableView()
        self.showActivityIndicator()
        loadCarManufacturers()
    }
    
    
    func configureTableView() {
        self.tableView.register(UINib(nibName: "AOManufacturerCell", bundle: nil), forCellReuseIdentifier: CellIdentifer.manufacturer.rawValue)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 60.0
        
        //Add Spinner as footer view
        let spinnerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.tableView.bounds.size.width, height: 50.0))
        let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        spinner.startAnimating()
        spinner.center = spinnerView.center
        spinnerView.backgroundColor = UIColor.clear
        spinnerView.addSubview(spinner)
        self.tableView.tableFooterView = spinnerView
    }
    


    ///------------------------------------------------
    
    /// Helper method
    /// 1. To fetch the Manufacturer list from server.
    /// 2. Process the response and display it on lis
    /// 3. It also displays the alert in case of error.
    private func loadCarManufacturers() {
        
        // The page number will be non-zero when there are items to loads. If all data is fetched it will be set to 0 to avoid
        // Unncessary request.
        if self.page > 0 {

            self.tableView.isUserInteractionEnabled = false
            //Pass page no , page size
        
            AONetworkService.startService(with: AONetworkRouter.shared.manufacturerRequest(with: page, pageSize: pageSize), onCompletion: {
                (response,error) in
                self.hideActivityIndicator()
                if let response = response, let list = response["wkda"] as? [String : String] {
                    //Increment the page number if the response has items count == pageSize. number of items > pageSize means no more data.
                    if list.count == self.pageSize {
                        self.page = self.page + 1
                    }
                    else {
                        //Setting the page number to 0, to turn-off pagination.
                        //This also indicates the all data is fetched.
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
    
    private func refresh(with list : [String : String]) {
        //The loaded are sorted on random order, so sorting it again on Key.
        for item in list.sorted(by: {$0.key < $1.key}) {
            let obj = AOManufacturer(id: item.key, name: item.value)
            self.manufacturerList.append(obj)
        }
        self.tableView.reloadData()
        self.tableView.isUserInteractionEnabled = true
        self.tableView.tableFooterView?.isHidden = true
        
    }
}

extension AOManufacturerListController : UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.manufacturerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: CellIdentifer.manufacturer.rawValue, for: indexPath) as! AOManufacturerCell
        let manufacturer = self.manufacturerList[indexPath.row]
        cell.nameLabel.text = manufacturer.name
        
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
        let modelListControllerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ModelListController") as! AOModelListController
        modelListControllerVC.manufacturer = self.manufacturerList[indexPath.row]
        self.navigationController?.pushViewController(modelListControllerVC, animated: true)
    }
        
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //Show spinner while loading data.
        if indexPath.row == (self.manufacturerList.count - 1) && self.page > 0 {
            self.tableView.tableFooterView?.isHidden = false
        }
     }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let endOffset = scrollView.contentOffset
        //Refresh on Scroll down
        if draggingOffset.y < endOffset.y {
            if let lastIndexPath = tableView.indexPathsForVisibleRows?.last {
                if lastIndexPath.row >= (self.manufacturerList.count / 2) {
                    self.loadCarManufacturers()
                }
            }
        }
        
    }
        
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        draggingOffset = scrollView.contentOffset
    }
    

    

}
