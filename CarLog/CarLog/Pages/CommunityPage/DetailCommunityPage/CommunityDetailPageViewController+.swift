//
//  CommunityDetailPageViewController+.swift
//  CarLog
//
//  Created by 김은경 on 11/7/23.
//

import UIKit

import FirebaseAuth

extension CommunityDetailPageViewController {}

extension CommunityDetailPageViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = ""
            textView.textColor = UIColor.lightGray
        }
    }
}

// MARK: - Community 사진

extension CommunityDetailPageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let selectedPost = selectedPost else {
            return 0
        }

        return selectedPost.image.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommunityDetailCell", for: indexPath) as! CommunityDetailCollectionViewCell
        guard let selectedPost = selectedPost, indexPath.item < selectedPost.image.count else { return cell }
        let imageURL = selectedPost.image[indexPath.item]
        if let url = imageURL {
            URLSession.shared.dataTask(with: url) { data, _, error in
                DispatchQueue.main.async {
                    if let data = data, let image = UIImage(data: data) {
                        cell.imageView.image = image
                        self.photoCollectionView.snp.makeConstraints { make in
                            make.size.equalTo(CGSize(width: 360, height: 345))
                        }
                    } else if let error = error {
                        print("Error downloading image: \(error.localizedDescription)")
                    }
                }
            }.resume()
        }

        return cell
    }
}

// MARK: - Community 댓글 tableview

extension CommunityDetailPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
        let comment = commentData.sorted(by: {$0.timeStamp ?? "" > $1.timeStamp ?? ""})[indexPath.row]
        cell.userNameLabel.text = comment.userName
        cell.dateLabel.text = comment.timeStamp
        cell.commentLabel.text = comment.content
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension // 또는 적절한 높이 값
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: nil) { _, _, _ in
            if let post = self.selectedPost {
                let postID = post.id ?? ""
                FirestoreService.firestoreService.loadComments(postID: postID) { comments in
                    if let comments = comments {
                        for comment in comments {
                            print("commentID: \(comment.id)")
                            if comment.id == self.commentData[indexPath.row].id {
                                self.commentData.remove(at: indexPath.row)
                                tableView.deleteRows(at: [indexPath], with: .fade)
                                _ = tableView.rectForRow(at: indexPath).height
                                FirestoreService.firestoreService.removeComment(commentId: comment.id ?? "") { err in
                                    if err != nil {
                                        print("err")
                                    }
                                }
                                tableView.reloadData()
                            }
                            break
                        }
                    }
                }
            }
        }
        deleteAction.image = UIImage(named: "trash")
        deleteAction.backgroundColor = .backgroundCoustomColor

        let reportAction = UIContextualAction(style: .destructive, title: nil) { _, _, _ in
            if let post = self.selectedPost {
                FirestoreService.firestoreService.loadComments(postID: post.id ?? "") { comments in
                    for var comment in comments ?? [] {
                        var isBlocked = comment.blockComment?[Constants.currentUser.userEmail ?? ""]
                        isBlocked = !(isBlocked ?? false)
                        comment.blockComment?.updateValue(isBlocked ?? false, forKey: Constants.currentUser.userEmail ?? "")
                        FirestoreService.firestoreService.updateComment(commentId: comment.id ?? "", isBlocked: comment.blockComment ?? [:])
                        
                        if comment.id == self.commentData[indexPath.row].id {
                            self.commentData.remove(at: indexPath.row)
                            tableView.deleteRows(at: [indexPath], with: .fade)
                        }
                        break
                    }
                }
            }
        }
        reportAction.image = UIImage(named: "report") // 시스템 아이콘 사용
        reportAction.backgroundColor = .backgroundCoustomColor

        // 스와이프 액션을 구성합니다.
        let configuration: UISwipeActionsConfiguration

        if let currentUserEmail = Constants.currentUser.userEmail,
           let commentUserEmail = commentData[indexPath.row].userEmail,
           currentUserEmail == commentUserEmail
        {
            configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        } else {
            configuration = UISwipeActionsConfiguration(actions: [reportAction])
        }

        return configuration
    }
}
