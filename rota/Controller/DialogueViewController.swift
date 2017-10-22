//
//  DialogueViewController.swift
//  rota
//
//  Created by 荒川陸 on 2017/10/22.
//  Copyright © 2017年 Riku Arakawa. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import SVProgressHUD
import SCLAlertView

struct User {
    let id: String
    let name: String
}

class DialogueViewController: JSQMessagesViewController {
    
    let screenSize = UIScreen.main.bounds.size
    var height: CGFloat {
        return screenSize.height
    }
    var width: CGFloat {
        return screenSize.width
    }
    
    let user1 = User(id: "1", name: "doctor")
    let user2 = User(id: "2", name: "yoshimaro")
    
    var currentUser: User {
        return user1
    }
    
    var messages = [JSQMessage]()
    var displayMessages = [JSQMessage]()
    var count = 0
    
}

extension DialogueViewController {
    
    //送信ボタンが押された時の挙動
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let message = JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text)
        
        displayMessages.append(message!)
        
        finishSendingMessage()
    }
    
    //添付ファイルボタンが押された時の挙動
    override func didPressAccessoryButton(_ sender: UIButton!) {
        
    }
    
    //各送信者の表示について
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.row]
        let messageUsername = message.senderDisplayName
        
        return NSAttributedString(string: messageUsername!)
    }
    
    //各メッセージの高さ
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 15
    }
    
    //各送信者の表示に画像を使うか
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    //各メッセージの背景を設定
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        
        let message = messages[indexPath.row]
        
        if currentUser.id == message.senderId {
            return bubbleFactory?.outgoingMessagesBubbleImage(with: .green)
        } else {
            return bubbleFactory?.incomingMessagesBubbleImage(with: .blue)
        }
    }
    
    //   メッセージの総数を取得
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayMessages.count
    }
    
    //   メッセージの内容参照場所の設定
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return displayMessages[indexPath.row]
    }
}

extension DialogueViewController {
    //   画面を開いた直後の挙動。ここで使用者側の設定を行ない、過去のメッセージを取得している
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.senderId = currentUser.id
        self.senderDisplayName = currentUser.name
        
        //   メッセージ取得の関数（真下）呼び出し
        initializeMessageArray()
        
        //   ボタン生成
        let btnWidth: CGFloat = 100
        let btnHeight: CGFloat = 50
        
        let yesBtn = UIButton(frame: CGRect(x: width/2+btnWidth/3, y: height/2+btnHeight*1.5,
                                            width: btnWidth, height: btnHeight))
        yesBtn.setTitle("YES", for: .normal)
        yesBtn.backgroundColor = UIColor.red
        yesBtn.addTarget(self, action: #selector(self.yes(_:)), for: .touchUpInside)
        self.view.addSubview(yesBtn)
        
        let noBtn = UIButton(frame: CGRect(x: width/2+btnWidth/3, y: height/2+btnHeight*2.5+10,
                                            width: btnWidth, height: btnHeight))
        noBtn.setTitle("NO", for: .normal)
        noBtn.backgroundColor = UIColor.red
        noBtn.addTarget(self, action: #selector(self.no(_:)), for: .touchUpInside)
        self.view.addSubview(noBtn)
        
        sendNextMessage()
        sendNextMessage()
        sendNextMessage()
    }
}

extension DialogueViewController {
    
    @objc func yes(_ sender: AnyObject) {
        SCLAlertView().showWarning("Warning", subTitle: "Your baby might be Dehydration or have RotaVirus. \n You should take your baby to the nearest hospital ASAP with the pacifier in the package. \n You should be careful about secondary infection. WASH YOUR HANDS!!")
    }
    
    @objc func no(_ sender: AnyObject) {
        sendNextMessage()
    }
}


extension DialogueViewController {
    
    //   メッセージ配列を初期化、呼び出し関数作成
    func initializeMessageArray() {
        // 初期化
        messages = [JSQMessage]()
        displayMessages = [JSQMessage]()
        
        let message0 = JSQMessage(senderId: "2", displayName: "doctor", text: "Hi")
        let message1 = JSQMessage(senderId: "2", displayName: "doctor", text: "Please answer some questions to see your baby's condtion.")
        let message2 = JSQMessage(senderId: "2", displayName: "doctor",
                                  text: "Does your baby have fever or diarrhea?")
        let message3 = JSQMessage(senderId: "2", displayName: "doctor",
                                  text: "Is your baby refusing food or drink?")
        let message4 = JSQMessage(senderId: "2", displayName: "doctor",
                                  text: "Does your baby seem sluggish or unresponsive?")
        
        messages.append(message0!)
        messages.append(message1!)
        messages.append(message2!)
        messages.append(message3!)
        messages.append(message4!)
    }
    
    // 次のメッセージを表示
    func sendNextMessage() {
        if count == messages.count {
            SCLAlertView().showSuccess("OK", subTitle: "Your baby seems alright. However, you SHOULD wash your hands. ")
            return
        }
        
        displayMessages.append(messages[count])
        finishReceivingMessage(animated: true)
        count += 1
    }
    
}

