//
//  WeatherViewController.swift
//  Weather
//
//  Created by Mahmoud on 17/07/2025.
//

import Foundation

import UIKit

class WeatherViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    let searchField = UITextField()
    let searchButton = UIButton(type: .system)
    let tableView = UITableView()
    let suggestionsTableView = UITableView()

    var forecasts: [ForecastEntry] = []
    var citySuggestions: [City] = []
    let service = WeatherService()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }

    func setupUI() {
        searchField.placeholder = "Enter city name"
        searchField.borderStyle = .roundedRect
        searchField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

        searchButton.setTitle("Search", for: .normal)
        searchButton.addTarget(self, action: #selector(didTapSearch), for: .touchUpInside)

        let searchStack = UIStackView(arrangedSubviews: [searchField, searchButton])
        searchStack.axis = .horizontal
        searchStack.spacing = 8

        tableView.register(ForecastCell.self, forCellReuseIdentifier: ForecastCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 80

        suggestionsTableView.dataSource = self
        suggestionsTableView.delegate = self
        suggestionsTableView.isHidden = true

        let stack = UIStackView(arrangedSubviews: [searchStack, suggestionsTableView, tableView])
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc func didTapSearch() {
        performSearch()
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let query = textField.text, query.count > 2 else {
            citySuggestions = []
            suggestionsTableView.isHidden = true
            suggestionsTableView.reloadData()
            return
        }
        service.fetchCitySuggestions(query: query) { [weak self] cities in
            DispatchQueue.main.async {
                self?.citySuggestions = cities
                self?.suggestionsTableView.isHidden = false
                self?.suggestionsTableView.reloadData()
            }
        }
    }

    func performSearch() {
        guard let city = searchField.text, !city.isEmpty else { return }
        service.fetchForecast(for: city) { [weak self] entries in
            DispatchQueue.main.async {
                self?.forecasts = entries ?? []
                self?.tableView.reloadData()
            }
        }
        view.endEditing(true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == suggestionsTableView ? citySuggestions.count : forecasts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == suggestionsTableView {
            let cell = UITableViewCell()
            let city = citySuggestions[indexPath.row]
            cell.textLabel?.text = "\(city.name), \(city.country)"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ForecastCell.identifier, for: indexPath) as! ForecastCell
            cell.configure(with: forecasts[indexPath.row])
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == suggestionsTableView {
            let selectedCity = citySuggestions[indexPath.row]
            searchField.text = selectedCity.name
            suggestionsTableView.isHidden = true
            service.fetchForecastForCoordinates(lat: selectedCity.lat, lon: selectedCity.lon) { [weak self] entries in
                DispatchQueue.main.async {
                    self?.forecasts = entries ?? []
                    self?.tableView.reloadData()
                }
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        performSearch()
        return true
    }
} // End
