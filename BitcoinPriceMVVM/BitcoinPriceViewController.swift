//
//  ViewController.swift
//  BitcoinPriceMVVM
//
//  Created by Marco Alonso Rodriguez on 03/06/23.
//

import UIKit
import SwiftUI
import Combine

class BitcoinPriceViewController: UIViewController {
    
    private let bitcoinViewModel = BitcoinViewModel(apiclient: APIClient.shared)
    
    ///Guardar informacion (bindings del viewModel)
    var cancellables = Set<AnyCancellable>()
    
    private let gradientLayer : CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.orange.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        return gradientLayer
    }()
    
    private let labelTitle: UILabel = {
        let label = UILabel()
        label.text = "Bitcoin Price"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        label.font = .systemFont(ofSize: 40, weight: .semibold, width: .standard)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let labelPrice: UILabel = {
        let label = UILabel()
        label.text = "$123456.7"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        label.font = .systemFont(ofSize: 50, weight: .bold, width: .standard)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let labelDate: UILabel = {
        let label = UILabel()
        label.text = "03 Jun 2023"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .regular, width: .standard)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let currencyPickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.layer.cornerRadius = 15
        picker.layer.borderWidth = 1
        picker.layer.borderColor = UIColor.white.cgColor
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private var bitcoinImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bitcoin")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //Crear un label para mostrar si hay un error del viewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPickerView.delegate = self
        currencyPickerView.dataSource = self
        
        configurarElementos()
        
        createBindingsWithViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getPrice(wit: bitcoinViewModel.exchangeRate.first ?? "MXN")
    }
    
    private func getPrice(wit currency: String) {
        bitcoinViewModel.getPrice(with: currency)
    }
    
    ///DataBindings (Tuberias)
    private func createBindingsWithViewModel() {
        ///Se crea un binding del viewModel hacia el labelPrice -> bitcoinPrice
        // Opcion 1
//        bitcoinViewModel.$bitcoinPrice
//            .assign(to: \UILabel.text!, on: labelPrice)
//            .store(in: &cancellables)
//
//        ///Se crea un binding de la propiedad dateLastPrice para mostrar label con la fecha
//        bitcoinViewModel.$dateLastPrice
//            .assign(to: \UILabel.text!, on: labelDate)
//            .store(in: &cancellables)
        
        
        ///Se crea el binding para escuchar cuando cambia el valor de $bitcoinPrice y poder actualizar la vista
        // Opcion 2
        bitcoinViewModel.$bitcoinPrice.sink { price in
            print("price: \(price)")
            self.labelPrice.text = price
        }.store(in: &cancellables)
        
        
        bitcoinViewModel.$dateLastPrice.sink { date in
            print("price: \(date)")
            self.labelDate.text = date
        }.store(in: &cancellables)
    }
    
    ///Agregando los elemento a la vista, constraints
    private func configurarElementos(){
        gradientLayer.frame = view.bounds
        view.layer.addSublayer(gradientLayer)
        
        view.addSubview(labelTitle)
        view.addSubview(labelPrice)
        view.addSubview(labelDate)
        view.addSubview(currencyPickerView)
        view.addSubview(bitcoinImage)
        
        ///Constraints
        NSLayoutConstraint.activate([
            labelTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelTitle.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            labelTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            labelTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            labelTitle.heightAnchor.constraint(equalToConstant: 60),
            
            labelPrice.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelPrice.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 30),
            labelPrice.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            labelPrice.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            labelPrice.heightAnchor.constraint(equalToConstant: 60),
            
            labelDate.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelDate.topAnchor.constraint(equalTo: labelPrice.bottomAnchor, constant: 20),
            
            currencyPickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currencyPickerView.topAnchor.constraint(equalTo: labelDate.bottomAnchor, constant: 20),
            currencyPickerView.heightAnchor.constraint(equalToConstant: 120),
            
            bitcoinImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bitcoinImage.topAnchor.constraint(equalTo: currencyPickerView.bottomAnchor, constant: 20),
            bitcoinImage.heightAnchor.constraint(equalToConstant: 150)
        ])
    }

}

extension BitcoinPriceViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return bitcoinViewModel.exchangeRate.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return bitcoinViewModel.exchangeRate[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(bitcoinViewModel.exchangeRate[row])
        
        let currency = bitcoinViewModel.exchangeRate[row]
        getPrice(wit: currency)
    }
    
    
}

// MARK:  Preview
struct ViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = BitcoinPriceViewController
    
    func makeUIViewController(context: Context) -> BitcoinPriceViewController {
        BitcoinPriceViewController()
    }
    
    func updateUIViewController(_ uiViewController: BitcoinPriceViewController, context: Context) {
        
    }
}

struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerRepresentable()
    }
}



