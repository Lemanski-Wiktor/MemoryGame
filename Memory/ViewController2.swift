//
//  ViewController2.swift
//  Memory
//
//  Created by Wiktor Lemański on 02/12/2022.
//

import UIKit
//import PlaygroundSupport
//PlaygroundPage.current.needsIndefiniteExecution = true

class ViewController2: UIViewController {
    
    var level = 0
    var isHorizontal = false
    var easyImgs: ArraySlice<String> = []
    var hardImgs: Array<String> = []
    var numOfActiveCards = 0
    var activeCards: Array<String> = []
    var activeCardsBtns: Array<UIButton> = []
    var openBtnsTags: Array<Int> = []
    var tagsImage: [Int: String] = [:]
    var allImgs = 0
    var numOfMoves = 0
    var images: Array<String> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 1...14{
            images.append("image\(i)")
        }
        images.shuffle()
        
        var tag = 0
        if(level == 0){
            easyImgs = images[0...5]
            easyImgs += images[0...5]
            easyImgs.shuffle()
            allImgs = easyImgs.count
            for i in 0..<4{
                for j in 0..<3{
                    tag+=1
                    if(!isHorizontal){
                        createSquare(x: i,y: j,size: 187, tag: tag)
                    }else{
                        createSquare(x: i,y: j,size: 206, tag:tag)
                    }
                }
            }
        }else if(level==1){
            hardImgs = images
            hardImgs += images
            hardImgs.shuffle()
            allImgs = hardImgs.count
            for i in 0..<7{
                for j in 0..<4{
                    tag+=1
                    if(!isHorizontal){
                        createSquare(x: i,y: j,size: 104, tag: tag)
                    }else{
                        createSquare(x: i,y: j,size: 144, tag:tag)
                    }
                }
            }
        }
    }
    
    @objc func selectImg(sender:UIButton){
        
        numOfActiveCards += 1
        var img = UIImage(named: "mark.png")
        if(level==0){
            img = UIImage(named: easyImgs[sender.tag - 1])!
            activeCards.append(easyImgs[sender.tag - 1])
            tagsImage.updateValue(easyImgs[sender.tag - 1], forKey: sender.tag)
        }else if(level==1){
            img = UIImage(named: hardImgs[sender.tag - 1])!
            activeCards.append(hardImgs[sender.tag - 1])
            tagsImage.updateValue(hardImgs[sender.tag - 1], forKey: sender.tag)
        }
        
        
        if(numOfActiveCards < 3){
            sender.setBackgroundImage(img, for: UIControl.State.normal)
            activeCardsBtns.append(sender)
            sender.isUserInteractionEnabled = false
            openBtnsTags.append(sender.tag)
            
            if(numOfActiveCards == 2){
                let uniqArray = Array(Set(activeCards))
                let tmp1 = uniqArray.sorted()
                let tmp2 = activeCards.sorted()
                
                if(tmp1 == tmp2){
                    numOfMoves += 1
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        
                        self.activeCardsBtns[0].setBackgroundImage(UIImage(named: "mark.png"), for: UIControl.State.normal)
                        self.activeCardsBtns[0].isUserInteractionEnabled = true
                        
                        self.activeCardsBtns[1].setBackgroundImage(UIImage(named: "mark.png"), for: UIControl.State.normal)
                        self.activeCardsBtns[1].isUserInteractionEnabled = true
                        
                        self.openBtnsTags.removeLast()
                        self.openBtnsTags.removeLast()
                        
                        self.activeCardsBtns = []
                        self.activeCards = []
                        self.numOfActiveCards = 0
                    }
                }else{
                    
                    numOfMoves += 1
                    activeCardsBtns = []
                    activeCards = []
                    numOfActiveCards = 0
                }
            }
            
            if(openBtnsTags.count == allImgs){
                let alert = UIAlertController(title: "Summary", message: "Congratulations! You win in \(numOfMoves) moves!", preferredStyle: .alert)
                
                let returnHome = UIAlertAction(title: "Return", style: .default){_ in
                    self.navigationController?.popViewController(animated: true)
                }
                
                alert.addAction(returnHome)
                
                present(alert,animated: true)
            }
        }
    }
    
    func createSquare(x: Int, y: Int, size: Int, tag: Int){
        let button : UIButton = UIButton()
        var img = UIImage(named : "mark.png")!
        button.tag = tag
        if(openBtnsTags.contains(tag)){
            img = UIImage(named: tagsImage[tag]!)!
            button.setBackgroundImage(img, for: UIControl.State.normal)
        }else{
            button.setBackgroundImage(img, for: UIControl.State.normal)
        }
        
        if(level==0){
            if(!isHorizontal){
                button.frame = CGRect(x: x*size+4*(x+1), y: y*size+259+4*(y+1), width: size, height: size)
            }else{
                button.frame = CGRect(x: x*size+40*(x+1), y: y*size+24+40*(y+1), width: size, height: size)
            }
        }else if(level==1){
            if(!isHorizontal){
                button.frame = CGRect(x: x*size+5*(x+1), y: y*size+328+5*(y+1), width: size, height: size)
            }else{
                button.frame = CGRect(x: x*size+2*(x+1), y: y*size+128+2*(y+1), width: size, height: size)
            }
        }
        
        button.addTarget(self, action: #selector(selectImg), for: UIControl.Event.touchUpInside)
        
        self.view.addSubview(button)
        
        if(activeCardsBtns.count == 1){
            let tmpTag = activeCardsBtns[0].tag
            let newButton = self.view.viewWithTag(tmpTag)!
            activeCardsBtns[0] = newButton as! UIButton
        }else if(activeCardsBtns.count == 2){
            let tmpTag1 = activeCardsBtns[0].tag
            let tmpTag2 = activeCardsBtns[1].tag
            let newButton1 = self.view.viewWithTag(tmpTag1)!
            let newButton2 = self.view.viewWithTag(tmpTag2)!
            activeCardsBtns[0] = newButton1 as! UIButton
            activeCardsBtns[1] = newButton2 as! UIButton
        }
    }
    
    func removeButton(tag: Int){
        self.view.viewWithTag(tag)!.removeFromSuperview()
    }
    @objc func returnHome(){
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        isHorizontal = UIDevice.current.orientation.isLandscape
        
        var tag = 0
        if(level == 0){
            for i in 0..<4{
                for j in 0..<3{
                    tag+=1
                    if(!isHorizontal){
                        removeButton(tag: tag)
                        createSquare(x: i,y: j,size: 187, tag: tag)
                    }else{
                        removeButton(tag: tag)
                        createSquare(x: i,y: j,size: 206, tag:tag)
                    }
                    
                }
            }
        }else if(level==1){
            for i in 0..<7{
                for j in 0..<4{
                    tag+=1
                    if(!isHorizontal){
                        removeButton(tag: tag)
                        createSquare(x: i,y: j,size: 104, tag: tag)
                    }else{
                        removeButton(tag: tag)
                        createSquare(x: i,y: j,size: 144, tag:tag)
                    }
                    
                }
            }
        }
    }
}
