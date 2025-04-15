import UIKit

class FavoritesViewController: UIViewController {
    
    private let tableView = UITableView()
    private let viewModel = FavoritesViewModel()
    private let emptyStateLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEmptyStateLabel()
    }
    
    private func setupUI() {
        title = "Favori Uçuşlar"
        view.backgroundColor = .systemBackground
        
        // TableView ayarları
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavoriteFlightCell.self, forCellReuseIdentifier: "FavoriteFlightCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        
        // TableView ekleme
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupEmptyStateLabel() {
        emptyStateLabel.text = "Favori uçuşunuz bulunmamaktadır."
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.textColor = .gray
        emptyStateLabel.font = UIFont.systemFont(ofSize: 16)
        emptyStateLabel.numberOfLines = 0
        
        view.addSubview(emptyStateLabel)
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // Başlangıçta gizli olsun
        emptyStateLabel.isHidden = true
    }
    
    private func updateEmptyStateVisibility() {
        // Favori uçuş yoksa mesajı göster, varsa gizle
        emptyStateLabel.isHidden = !viewModel.favoriteFlights.isEmpty
        tableView.isHidden = viewModel.favoriteFlights.isEmpty
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadFavorites() // güncellenmis favori ucuslarını ceker direkt
        tableView.reloadData()
        updateEmptyStateVisibility()
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favoriteFlights.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteFlightCell", for: indexPath) as? FavoriteFlightCell else {
            return UITableViewCell()
        }
        
        let flight = viewModel.favoriteFlights[indexPath.row]
        cell.configure(with: flight)
        return cell
    }
    
    // Favorilerden kaldırma özelliği
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { _, _, completion in
            let flight = self.viewModel.favoriteFlights[indexPath.row]
            self.viewModel.removeFlightFromFavorites(flight)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.updateEmptyStateVisibility() // Silme sonrası empty state kontrol et
            completion(true)
        }
        deleteAction.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    // Uçuşa tıklayınca detay sayfasına gitme
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let flight = viewModel.favoriteFlights[indexPath.row]
        let detailVC = FlightDetailViewController(flight: flight)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
