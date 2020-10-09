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
    }
    
    //MARK: - Private
    private func configureCells() {
        self.cells = []
         
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

        self.cells = [
            MediaActionsCell(
                item: holderType +
                    self.postingMedia.map({ value -> (CreatePostMediaHolderTableViewCell.MediaHolderType) in .media(value, self) })
            )
        ]
        
        self.cells.append(TitleCell(item: ""))
        self.cells.append(BodyCell(item: ""))
        
        self.tableView.reloadData()
    }
    
    private func showCameraView() {
        self.present(self.cameraVC, animated: true)
    }
    
    private func showTemplate() {
        let vc = TemplateMediaPickerViewController.newInstance()
        self.present(vc, animated: true)
    }
}

//MARK: - TableViewDelegate
extension CreatePostViewController: UITableViewDelegate, UITableViewDataSource {
    typealias MediaActionsCell = TableCellConfigurator<CreatePostMediaHolderTableViewCell, [CreatePostMediaHolderTableViewCell.MediaHolderType]>
    typealias TitleCell = TableCellConfigurator<PostTitleTableViewCell, String>
    typealias BodyCell = TableCellConfigurator<PostBodyTableViewCell, String>
    
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
