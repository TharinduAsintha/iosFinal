//
//  CustomeButton.swift
//  MHTABandara-COBSCCOMP191P-024
//
//  Created by Ponna Tharindu on 9/18/20.
//

import UIKit

class CustomeButton: UIButton
{
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setupButton()
    }
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
        setupButton()
    }
    private func setupButton()
    {
        layer.cornerRadius = frame.size.height/4
    }
}
