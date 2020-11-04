//
//  HomeViewController.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-10-16.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit
import SDWebImage
import UIScrollView_InfiniteScroll

class HomeViewController: UIViewController {
    static let identifier = "HomeViewController"
    
    @IBOutlet private weak var collectionView: UICollectionView!

    class func newInstance() -> HomeViewController {
        return homeStoryboard.instantiateViewController(withIdentifier: self.identifier) as! HomeViewController
    }
    
    private var critiques: [Critique] = []
    private var critiqueManager: CritiqueManager {
        return .sharedInstance
    }
    private var hasNextPage: Bool = false
    
    private lazy var refreshControl: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(self.refreshTriggered(sender:)), for: .valueChanged)
        return refresher
    }()
    
    private struct Constant {
        static var titleFont: UIFont = .systemFont(ofSize: 17, weight: .semibold)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = .init(title: "Create", style: .plain, target: self, action: #selector(self.createButtonPressed))
        self.navigationItem.title = devEnvironment.homePageBarTitle
        
        self.collectionView.refreshControl = self.refreshControl
        self.setupLayout()
        
        self.collectionView.addInfiniteScroll() { _ in
            self.loadContent()
        }
        
        self.collectionView.setShouldShowInfiniteScrollHandler() { _ in
            return true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if STLoginManager.sharedInstance.currentSession?.id == nil {
            let vc = LoginNavigationController.newInstance()
            self.present(vc, animated: true)
        } else {
            self.checkIfProfileComplete()
        }
        
        self.loadContent()
    }
    
    private func checkIfProfileComplete() {
        guard let session = STLoginManager.sharedInstance.currentSession else { return }
        
        if !session.isProfileComplete {
            let vc = ProfileCompletionViewController.newInstance()
            self.present(vc, animated: true)
        }
    }
    
    private func loadContent(shouldReload: Bool = false) {
        let after = shouldReload ? nil : self.critiques.last?.id
        self.critiqueManager.getHomeCritiques(after: after) { result, hasNextPage in
            if self.critiques.isEmpty || shouldReload {
                self.critiques = result ?? []
                self.collectionView.collectionViewLayout.invalidateLayout()
                self.collectionView.reloadData()
            } else if let result = result, !result.isEmpty {
                let endIdx = self.critiques.count
                self.critiques.append(contentsOf: result)
                let newResultsIdx = (endIdx...(self.critiques.count - 1)).map({ IndexPath(row: $0, section: 0) })
                self.collectionView.performBatchUpdates({
                    self.collectionView.insertItems(at: newResultsIdx)
                }, completion: { _ in
                    self.collectionView.finishInfiniteScroll()
                })
            }
            self.hasNextPage = hasNextPage
            self.refreshControl.endRefreshing()
        }
    }
    
    private func setupLayout() {
        let layout: PinterestLayout = {
            if let layout = self.collectionView.collectionViewLayout as? PinterestLayout {
                return layout
            }
            let layout = PinterestLayout()

            collectionView?.collectionViewLayout = layout

            return layout
        }()
        layout.delegate = self
        layout.cellPadding = 5
        layout.numberOfColumns = 2
    }
    
    //MARK: - IBAction
    @objc private func createButtonPressed() {
        let vc = CreatePostViewController.newInstance()
        self.present(vc, animated: true)
    }
    
    @objc func refreshTriggered(sender: UIRefreshControl) {
        self.loadContent(shouldReload: true)
    }
}

extension HomeViewController: PinterestLayoutDelegate {
    func collectionView(collectionView: UICollectionView,
                        heightForImageAtIndexPath indexPath: IndexPath,
                        withWidth: CGFloat) -> CGFloat {
        return withWidth
    }
    
    func collectionView(collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: IndexPath,
                        withWidth: CGFloat) -> CGFloat {
        //80 is the constant height of the author view + margins
        return self.critiques[indexPath.row].title.heightForWidth(width: withWidth - 10, font: Constant.titleFont) + 55
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.critiques.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCritiqueCollectionViewCell.identifier, for: indexPath) as! HomeCritiqueCollectionViewCell

        cell.configureCell(critique: self.critiques[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc: PostViewController = .newInstance(critique: self.critiques[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

