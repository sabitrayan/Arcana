import UIKit
import FirebaseDatabase
class MenuViewController: UIViewController {
    let ref = Database.database().reference().child("arcana").child("burger")
    var products = [Product]()
    var catalogProducts = Products.hamburgersList
    
    private let tableView: UITableView = {
        let tabelView = UITableView()
        tabelView.register(MenuTableViewCell.self, forCellReuseIdentifier: MenuTableViewCell.menuCellID)
        return tabelView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        retrieveProducts()
        func numberOfSectionsInTableView(tableView: UITableView) -> Int {
                return 1
            }

        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                    return self.products.count

            }
//        func tableView(tableView: UITableView,cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "CellProduct",for: indexPath as IndexPath) as! Product
//
//            var product = Product(snapshot: <#DataSnapshot#>)
//
//            product = products[indexPath.row]
//
//            cell.name.text = product.name
//            cell.price.text = product.price! + "€"
//
//            cell.name.textColor = UIColor(red: 114 / 255,
//                                                  green: 114 / 255,
//                                                  blue: 114 / 255,
//                                                  alpha: 1.0)
//            return cell
//            }

    }
   // func retrieveProducts(){
//        ref.queryOrdered(byChild: "book_price").observe(.childAdded, with: {
//            (snapshot) in
//
//            if let dictionary = snapshot.value as? [String:AnyObject]{
//
//                let product = Product(snapshot: Snapshot)
//
//                product.setValuesForKeysWithDictionary(dictionary)
//
//                        self.bookList.append(book)
//                        dispatch_async(dispatch_get_main_queue(), {
//                            self.tableView.reloadData()
//                        })
//
//
//                }
//            })

    func retrieveProducts(){
//        self.ref.getData { (error, snapshot) in
//            if let error = error {
//                print("Error getting data \(error)")
//            }
//            else if snapshot.exists() {
//                print("Got data \(snapshot.value!)")
//            }
//            else {
//                print("No data available")
//            }
//        }
       self.ref.observeSingleEvent(of: .value, with: {[weak self] (snapshot) in
            var _products = Array<Product>()
//            for _ in 1...100{
//                print("hfeawjiorbehuwjrfhi")
//                print(snapshot)
//            }

            for item in snapshot.children {
                let product = Product(snapshot: item as! DataSnapshot)
                _products.append(product)
            }

            self?.products = _products

            self?.tableView.reloadData()
        })

    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
    }

//        var collnum = ""
//        ref = Database.database().reference()
//        let collid = ref.child("collid").child("day")
//

//        collid.observeSingleEvent(of : .value, with : {(Snapshot) in
//
//                print(Snapshot)
//
//                if let snapDate = Snapshot.value as? String{
//                        collnum = snapDate
//                        print(snapDate)
//                }
//        })

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //refHandle = postRef.observe(DataEventType.value, with: { (snapshot) in
         // let postDict = snapshot.value as? [String : AnyObject] ?? [:]
          // ...
        //})

        self.ref.observeSingleEvent(of: .value, with: {[weak self] (snapshot) in
            var _products = Array<Product>()
            for item in snapshot.children {
                let product = Product(snapshot: item as! DataSnapshot)
                _products.append(product)
            }

            self?.products = _products

           //self?.MenuViewController.reloadData()
        })
        print(products)
    }
}

extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catalogProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.menuCellID, for: indexPath) as! MenuTableViewCell
        cell.product = catalogProducts[indexPath.row]
        return cell
    }
}

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}
