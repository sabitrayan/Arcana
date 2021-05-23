import UIKit

class MenuTableViewCell: UITableViewCell {
    static let menuCellID = "menuCellID"
    
    private let bgView = UIView()


    var icon: UIImageView = {
        let icon = UIImageView()
        
        icon.contentMode = .scaleToFill
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    var labelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var productName: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 13)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    var priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.font = .boldSystemFont(ofSize: 50)
        priceLabel.numberOfLines = 0
        priceLabel.textAlignment = .left
        priceLabel.adjustsFontSizeToFitWidth = true
        
        return priceLabel
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        return label
    }()

    
    var product: Product? {
        didSet {
            if let image = product?.icon {
                downloadImage(from: URL(string: image))
                //let fileUrl = URL(string: filePath)

                //UIImage(named: image)
            }
            if let descName = product?.description {
                descriptionLabel.text = descName
            }
            if let prodName = product?.name {
                productName.text = prodName
            }

            if let priceLbl = product?.price {
                priceLabel.text = String(priceLbl) + " \u{20B8}"
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addAllUIElementsInView()
        setupConstrainst()
    }
    
    private func addAllUIElementsInView() {
        addSubview(bgView)
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.addSubview(icon)
        bgView.addSubview(labelsStackView)
    }
    
    private func setupConstrainst() {
        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: topAnchor),
            bgView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bgView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bgView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            icon.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 5),
            icon.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -5),
            icon.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -5),
            icon.heightAnchor.constraint(equalToConstant: 75),
            icon.widthAnchor.constraint(equalToConstant: 120)
        ])
        
        [productName, descriptionLabel, priceLabel].forEach { labelsStackView.addArrangedSubview($0) }
        NSLayoutConstraint.activate([
            labelsStackView.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 20),
            labelsStackView.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 5),
            labelsStackView.trailingAnchor.constraint(equalTo: icon.leadingAnchor, constant: -10),
            labelsStackView.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -20),
        ])
    }
    
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

    func downloadImage(from url: URL?) {
        print("Download Started")
        guard let url = url else { return }
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                self?.icon.image = UIImage(data: data)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
