import UIKit
import FirebaseDatabase
class MenuViewController: UIViewController {
    let ref = Database.database().reference().child("arcana")
    var products = [Product]()
    //var catalogProducts = Products.hamburgersList

    private let tableView: UITableView = {
        let tabelView = UITableView()
        tabelView.register(MenuTableViewCell.self, forCellReuseIdentifier: MenuTableViewCell.menuCellID)
        return tabelView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        view.addSubview(tableView)
    }


    func retrieveProducts(){
        //self.ref.observeSingleEvent(of: .value, with: {[weak self] (snapshot) in
            //var _products = Array<Product>()
        ref.queryOrdered(byChild: "burger").observe(.childAdded, with: {
                   (snapshot) in
        //self?.products = [Product]()

            print(snapshot)
            print("HERE IS SNAPSHOT")
            //print(snapshot.childSnapshot(forPath: "burger1"))
            //for _ in snapshot.children {
                //let product = Product(snapshot: item as! DataSnapshot)
                let value = snapshot.value as? NSDictionary
                let name  = value?["name"] as? String ?? ""
                let price = value?["price"] as? Int ?? 0
                let icon  = value?["icon"] as? String ?? ""
                let description = value?["description"] as? String ?? ""

                let product = Product(name: name, price: price, icon: icon , description: description)

                self.products.append(product)
                //print(self.products)


            //}

            //self?.products = _products
            self.tableView.reloadData()
        })

    }

    private func setupTableView() {
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
    }



    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retrieveProducts()

    }
}

extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCellID",
                                                 for: indexPath) as! MenuTableViewCell

       // let product = products[indexPath.row]

        cell.product = products[indexPath.row]
        return cell
    }
}

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}
