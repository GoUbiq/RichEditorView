//
//  MediaEditingPageViewController.swift
//  UrbaniOS
//
//  Created by Bastien on 2020-11-11.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit

protocol MediaPageControllerDelegate: class {
    func shouldSetScrollEnable(enable: Bool)
}


class MediaEditingPageViewController: UIPageViewController {
    
    fileprivate var items: [UIViewController] = []

    var images: [UIImage] = []
    var pageDidChangeHandler: (() -> ())? = nil
    
    var currentIndex: Int {
        guard let vc = self.viewControllers?.first else { return 0 }
        return self.items.firstIndex(of: vc) ?? 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        self.items = self.images.compactMap({ MediaEditingEditorViewController.newInstance(img: $0, delegate: self) })

        if let firstViewController = self.items.first {
            self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func addProductTagOnCurrent(tag: ProductTag) {
        (self.items[safe: self.currentIndex] as? MediaEditingEditorViewController)?.addProductTag(tag: tag)
    }
    
    func addTextSticker() {
        (self.items[safe: self.currentIndex] as? MediaEditingEditorViewController)?.addTextSticker()
    }
}

extension MediaEditingPageViewController: MediaPageControllerDelegate {
    func shouldSetScrollEnable(enable: Bool) {
        self.isScrollEnabled = enable
    }
}

extension MediaEditingPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = self.items.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return self.items.last
        }
        
        guard self.items.count > previousIndex else {
            return nil
        }
        
        return self.items[previousIndex]
    }
    
    func pageViewController(_: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = self.items.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        guard self.items.count != nextIndex else {
            return self.items.first
        }
        
        guard self.items.count > nextIndex else {
            return nil
        }
        
        return self.items[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        self.pageDidChangeHandler?()
    }
}

    
