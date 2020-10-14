//
//  CreatePostViewController.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-09-29.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit

class CreatePostViewController: UIViewController {
    private static let identifier = "CreatePostViewController"
    
    //MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    
    //MARK: - Properties
    private var selectingCell: PostBodyTableViewCell? = nil
    private var cells: [CellConfigurator] = []
    private var postingMedia: [PostMedia] = []
    private lazy var cameraVC: CameraViewController = {
        return CameraViewController.newInstance(delegate: self)
    }()
    private var mediaHolderCollectionView: UICollectionView? {
        return (self.tableView.cellForRow(at: .zero) as? CreatePostMediaHolderTableViewCell)?.collectionView
    }
    
    //MARK: - VC Delegates
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Create Post"
        
        self.configureCells()
        
        self.tableView.isScrollEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShowNotification(_:)), name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHideNotification(_:)), name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Private
    private func configuredMediaCell() -> MediaActionsCell {
        let holderType: [CreatePostMediaHolderTableViewCell.MediaHolderType] = [
            .action(.init(
                image: #imageLiteral(resourceName: "add-camera"),
                title: "Camera",
                action: { self.showCameraView() })),
            .action(.init(
                image: #imageLiteral(resourceName: "flashOn"),
                title: "Template",
                action: { self.showTemplate()}))
        ]

        return MediaActionsCell(
            item: holderType +
                self.postingMedia.map({ value -> (CreatePostMediaHolderTableViewCell.MediaHolderType) in .media(value, self) })
        )
    }
    
    private func configureCells() {
        self.cells = []

        self.cells = [self.configuredMediaCell()]
        
        self.cells.append(TitleCell(item: ""))
        self.cells.append(BodyCell(item: .init(delegate: self)))
        
        self.tableView.reloadData()
    }
    
    private func showCameraView() {
        self.present(self.cameraVC, animated: true)
    }
    
    private func showTemplate() {
        let vc = TemplateMediaPickerViewController.newInstance()
        self.present(vc, animated: true)
    }
    
    // MARK: Notification
    @objc func keyboardWillShowNotification(_ notification: Notification) {
        if self.cells.first is MediaActionsCell {
            self.cells.remove(at: 0)
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [.zero], with: .automatic)
            self.tableView.endUpdates()
        }
    }
    
    @objc func keyboardWillHideNotification(_ notification: NSNotification) {
        if !(self.cells.first is MediaActionsCell) {
            self.cells.insert(self.configuredMediaCell(), at: 0)
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [.zero], with: .automatic)
            self.tableView.endUpdates()
        }
    }
}

//MARK: - TableViewDelegate
extension CreatePostViewController: UITableViewDelegate, UITableViewDataSource {
    typealias MediaActionsCell = TableCellConfigurator<CreatePostMediaHolderTableViewCell, [CreatePostMediaHolderTableViewCell.MediaHolderType]>
    typealias TitleCell = TableCellConfigurator<PostTitleTableViewCell, String>
    typealias BodyCell = TableCellConfigurator<PostBodyTableViewCell, PostBodyTableViewCell.CellInfo>
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.cells[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: type(of: item).reuseId, for: indexPath)
        item.configure(cell: cell)
        
        return cell
    }
}

extension CreatePostViewController: PostBodyCellDelegate, ProductTagPickerDelegate {
    func didPressAddProductTag(cell: PostBodyTableViewCell) {
        self.selectingCell = cell
        let vc = ProductTagPickerViewController.newInstance(delegate: self)
        self.present(vc, animated: true)
    }
    
    func didSelect(product: Product) {
        self.selectingCell?.addProductTag(product: product)
    }
}

//MARK: - Camera Delegate
extension CreatePostViewController: MediaManagementDelegate {
    func didCreateMedia(media: PostMedia) {
        self.postingMedia.append(media)
        self.configureCells()
    }
    
    func didDeleteMedia(media: PostMedia) {
        self.postingMedia.removeAll(where: { $0 == media })
        self.configureCells()
    }
}
