//
//  RecipeStepViewController.swift
//  CookNow
//
//  Created by Tobias on 14.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit

class RecipeStepViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    // The custom UIPageControl
    @IBOutlet weak var pageControl: UIPageControl!
    
    // The UIPageViewController
    var pageContainer: UIPageViewController!
    
    // The pages it contains
    var pages = [UIViewController]()
    
    // Track the current index
    var currentIndex: Int?
    private var pendingIndex: Int?
    
    var recipe: Recipe?
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        // Setup the pages
        if let recipe = recipe {
            for step in recipe.steps {
                let page: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "stepViewController")
                if let page = page as? StepViewController {
                    page.recipeID = recipe.id
                    page.step = step
                }
                pages.append(page)
            }
        }
        
        let endPage: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "finishStepViewController")
        pages.append(endPage)
        
        // Create the page container
        pageContainer = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageContainer.delegate = self
        pageContainer.dataSource = self
        if let first = pages.first {
            pageContainer.setViewControllers([first], direction: .forward, animated: false, completion: nil)
        }
        
        // Add it to the view
        self.addChildViewController(pageContainer)
        view.addSubview(pageContainer.view)
        
        //pageContainer.didMove(toParentViewController: self)
        
        // Configure our custom pageControl
        view.bringSubview(toFront: pageControl)
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
    }
    
    // MARK: - UIPageViewController delegates
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.index(of: viewController)!
        if currentIndex == 0 {
            return nil
        }
        let previousIndex = abs((currentIndex - 1) % pages.count)
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.index(of: viewController)!
        if currentIndex == pages.count-1 {
            return nil
        }
        let nextIndex = abs((currentIndex + 1) % pages.count)
        return pages[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingIndex = pages.index(of: pendingViewControllers.first!)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            currentIndex = pendingIndex
            if let index = currentIndex {
                pageControl.currentPage = index
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? SpeechViewController {
            destinationViewController.recipe = recipe
        }
    }
}
