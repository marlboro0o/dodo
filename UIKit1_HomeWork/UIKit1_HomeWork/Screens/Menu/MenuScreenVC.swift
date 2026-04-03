//
//  ViewController.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 23.01.2026.
//

import UIKit
import SnapKit

protocol IMenuScreenVC: AnyObject {
    func showProducts(products: [Product])
    func showCategories(categories: [Category])
    func showStories(stories: [Story])
    func updateBasket(sum: Int)
    func render(_ state: MenuPresenter.MenuState)
    
    func selectRow(category: Category)
}

final class MenuScreenVC: UIViewController {
    
    enum MenuSection: Int {
        case stories
        case banners
        case promo
        case products
    }
    
    let presenter: IMenuPresenter
    private var products: [Product] = [] {
        didSet {
            tableView.reloadSections(IndexSet(integer: MenuSection.products.rawValue), with: .automatic)
            tableView.reloadSections(IndexSet(integer: MenuSection.banners.rawValue), with: .automatic)
        }
    }

    private var categories: [Category] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private var stories: [Story] = [] {
        didSet {
            tableView.reloadSections(IndexSet(integer: MenuSection.stories.rawValue), with: .automatic)
        }
    }
    private var sumBasket = 0
    private var basketButton: BasketButton = {
        let button = BasketButton()
        button.setTitle("1000", for: .normal)
        button.isHidden = true
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init() //Инициализируем таблицу
        tableView.backgroundColor = .orange //Поставим цвет чтобы увидеть таблицу на вью
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
       
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(ProductCell.self)
        tableView.registerCell(BannerContainerCell.self)
        tableView.registerCell(PromoCell.self)
        tableView.registerCell(StoriesContainerCell.self)
        tableView.register(CategoryContainerCell.self, forHeaderFooterViewReuseIdentifier: CategoryContainerCell.reuseId)
        
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return tableView
    }()
    
    private let errorView: UIView = ErrorStateView()

    init(presenter: IMenuPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupConstraints()
        setupTargets()
    
        presenter.viewDidLoad()
    }
    
    @objc
    private func didTapBasket() {
//        present(
//            di.screenFactory.makeBasketVC(),
//            animated: true)
        presenter.showBasket()
    }
    
}

//MARK: UI
extension MenuScreenVC {
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(errorView)
        view.addSubview(tableView)
        view.addSubview(basketButton)
    }
    
    private func setupConstraints() {
        errorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        basketButton.snp.makeConstraints { make in
            make.right.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
    }
    
    private func setupTargets() {
        basketButton.addTarget(self, action: #selector(didTapBasket), for: .touchUpInside)
    }
}

//MARK: UITableViewDataSource
extension MenuScreenVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard
            let menuSection = MenuSection.init(rawValue: section)
        else {
            return 0
        }
        switch menuSection {
        case .stories:
            return 1
        case .banners:
            return 1
        case .promo:
            return 1
        case .products:
            return products.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard 
            let menuSection = MenuSection.init(rawValue: indexPath.section)
        else {
            return UITableViewCell()
        }
        
        switch menuSection {
        case .banners:
            let cell = tableView.dequeuCell(indexPath) as BannerContainerCell
            cell.update(products)
            return cell
        case .promo:
            let cell = tableView.dequeuCell(indexPath) as PromoCell
            return cell
        case .products:
            let cell = tableView.dequeuCell(indexPath) as ProductCell
            cell.update(products[indexPath.row])
            return cell
        case .stories:
            let cell = tableView.dequeuCell(indexPath) as StoriesContainerCell
            cell.update(stories)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let menuSection = MenuSection.init(rawValue: section) else { return nil }
        
        switch menuSection {
        case .products:
            guard 
                let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CategoryContainerCell.reuseId) as? CategoryContainerCell
            else {
                return UIView()
            }
            header.update(categories)
            header.onCategoryTap = { [weak self] category in
                guard let self else { return }
                self.presenter.didTapCategory(category: category)
            }
            
            return header
        default: return EmptyView.init()
        }
    }
}

//MARK: UITableViewDelegate
extension MenuScreenVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = MenuSection.init(rawValue: indexPath.section) else { return }
        
        if section == .products {
            presenter.didSelectProduct(index: indexPath.row)
        }
    }
}

//MARK: IMenuScreenVC
extension MenuScreenVC: IMenuScreenVC {
   
    func showProducts(products: [Product]) {
        self.products = products
    }
    
    func showCategories(categories: [Category]) {
        self.categories = categories
    }
    
    func showStories(stories: [Story]) {
        self.stories = stories
    }
    
    func updateBasket(sum: Int) {
        self.sumBasket = sum
        
        basketButton.setTitle("\(sum) P", for: .normal)
        basketButton.isHidden = sum == 0
    }
    
    func render(_ state: MenuPresenter.MenuState) {
        switch state {
        case .initial, .loading, .loaded:
            tableView.isHidden = false
            basketButton.isHidden = sumBasket == 0
            errorView.isHidden = true
        case .error:
            print("error")
            tableView.isHidden = true
            basketButton.isHidden = true
            errorView.isHidden = false
        }
    }
    
    func selectRow(category: Category) {
        let indexProduct = products.firstIndex(where: { $0.category == category } )
        
        let indexPath = IndexPath(row: indexProduct ?? 0, section: MenuSection.products.rawValue)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
    }
}

extension UIView {
    func applyShadow(cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        layer.shadowRadius = 4.0
        layer.shadowOpacity = 0.3
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        
    }
}

extension UITableView {
    func registerCell<Cell: UITableViewCell>(_ cellClass: Cell.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.reuseId)
    }
    func dequeuCell<Cell: UITableViewCell>(_ indexPath: IndexPath) -> Cell {
        guard
            let cell = dequeueReusableCell(withIdentifier: Cell.reuseId, for: indexPath) as? Cell
        else {
            fatalError("Fatal error for cell at \(indexPath)")
        }
        return cell
    }
}

protocol Reusable {
}

extension UITableViewCell: Reusable {
}

extension Reusable where Self: UITableViewCell {
    static var reuseId: String {
        return String.init(describing: self)
    }
}
