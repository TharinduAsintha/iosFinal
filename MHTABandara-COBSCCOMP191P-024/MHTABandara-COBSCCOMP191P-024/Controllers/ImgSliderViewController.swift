//
//  ImgSliderViewController.swift
//  WijekoonWHMCB-COBSCCOMP191P-006
//
//  Created by Chathura Wijekoon on 9/20/20.
//  Copyright © 2020 Chathura Wijekoon. All rights reserved.
//

import UIKit

class ImgSliderViewController: UIViewController, UIScrollViewDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrImages = [UIImage(named: "safety1"), UIImage(named: "safety2"), UIImage(named: "safety3")] as! [UIImage]

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    var arrImages : [UIImage] = []
    var arrLabelTitle : [UILabel] = []
    
    override func viewDidLayoutSubviews() {
         self.loadScrollView()
     }
    
     func loadScrollView() {
         let pageCount = arrImages.count
         scrollView.frame = view.bounds
         scrollView.delegate = self
         scrollView.backgroundColor = UIColor.clear
         scrollView.isPagingEnabled = true
         scrollView.showsHorizontalScrollIndicator = true
         scrollView.showsVerticalScrollIndicator = false
         
         pageControl.numberOfPages = pageCount
         pageControl.currentPage = 0
         
         for i in (0..<pageCount) {
             
             let imageView = UIImageView()
             imageView.frame = CGRect(x: i * Int(self.view.frame.size.width) , y: 200 , width:
                Int(self.view.frame.size.width) , height: 300)
             
             imageView.image = arrImages[i]
             self.scrollView.addSubview(imageView)
         }
         
         let width1 = (Float(arrImages.count) * Float(self.view.frame.size.width))
         scrollView.contentSize = CGSize(width: CGFloat(width1), height: self.view.frame.size.height)
         
         self.view.addSubview(scrollView)
         self.pageControl.addTarget(self, action: #selector(self.pageChanged(sender:)), for: UIControl.Event.valueChanged)

         self.view.addSubview(pageControl)
     }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
        print(pageNumber)
        
    }
    
    @objc func pageChanged(sender:AnyObject)
    {
        let xVal = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x: xVal, y: 0), animated: true)
        
    }    

    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: true)
        print("clicked")
    }
    
    
}
