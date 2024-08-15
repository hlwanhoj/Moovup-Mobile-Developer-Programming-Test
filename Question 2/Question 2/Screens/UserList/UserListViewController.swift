//
//  UserListViewController.swift
//  Question 2
//
//  Created by hlwan on 13/8/2024.
//

import Foundation
import UIKit
import ComposableArchitecture
import Then
import TinyConstraints
import API

class UserListViewController: UIViewController, UITableViewDelegate {
    private let store: Store<UserList.State, UserList.Action>
    private lazy var tableView = UITableView(frame: .zero, style: .plain)
    private var dataSource: UITableViewDiffableDataSource<UserListSection, UserListItem>!
    
    init(store: Store<UserList.State, UserList.Action>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tableView = UITableView(frame: .zero, style: .plain)
        let refreshControl = UIRefreshControl(frame: .zero, primaryAction: UIAction(handler: { [weak self] _ in
            self?.store.send(.reload)
        }))
        tableView.refreshControl = refreshControl
        self.tableView = tableView
        
        view.addSubviews {
            tableView
        }
        
        navigationItem.do {
            $0.title = "Users"
        }
        view.do {
            $0.backgroundColor = .white
        }
        tableView.do {
            $0.register(UserListCell.self, forCellReuseIdentifier: "cell")
            $0.rowHeight = 80
            $0.delegate = self
            $0.edgesToSuperview()
        }
        dataSource = UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            if let userCell = cell as? UserListCell {
                userCell.title = UserFormatter.name(for: itemIdentifier.user)
                userCell.iconUrl = itemIdentifier.user.pictureUrl
            }
            return cell
        }
        
        observe { [weak self] in
            guard let self else { return }
            dataSource.apply(store.snapshot)
        }
        observe { [weak self] in
            guard let self else { return }
            if !store.isLoading {
                refreshControl.endRefreshing()
            }
        }
        
        store.send(.reload)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        for indexPath in tableView.indexPathsForSelectedRows ?? [] {
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = dataSource.itemIdentifier(for: indexPath) {
            let detailVC = UserDetailViewController(
                store: Store(
                    initialState: UserDetail.State(
                        user: item.user
                    ),
                    reducer: {
                        UserDetail()
                    }
                )
            )
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

#Preview {
    UINavigationController(
        rootViewController: UserListViewController(
            store: Store(
                initialState: UserList.State(),
                reducer: {
                    UserList()
                },
                withDependencies: {
                    $0.userAPI.getUsers = {
                        [
                            User(id: "0000", name: nil, email: "abc@abc.com"),
                            User(id: "0001", name: User.Name(first: "Mei Ling", last: "Lee"), email: "def@abc.com", pictureUrlString: "https://placebear.com/222/207"),
                            User(id: "0002", name: User.Name(first: "Hans", last: "Wong"), email: "ghi@abc.com", pictureUrlString: "https://placebear.com/400/800"),
                            User(id: "0003", name: User.Name(first: "Alexander Benjamin Theodore Montgomery III", last: nil), email: "abc@abc.com", pictureUrlString: "https://placebear.com/800/400"),
                        ]
                    }
                }
            )
        )
    )
}
