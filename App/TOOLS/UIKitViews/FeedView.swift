//
//  FeedView.swift
//  FantasyWeibo (iOS)
//
//  Created by 赵翔宇 on 2022/1/22.
//

import SwiftUI
import SDWebImageSwiftUI

class TableViewController<Data ,Row : View>: UITableViewController {
    
    
    var content: (Data) -> Row
    var data: [Data]
    
    init(style: UITableView.Style,_ data: [Data], _ content: @escaping (_ data : Data) -> Row) {
        self.data = data
        self.content = content
        super.init(style: style)
        self.tableView.register(HostingCell<Row>.self, forCellReuseIdentifier: "tweet")
   
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 300
        self.tableView.backgroundColor = UIColor(Color.BackGround)
        self.tableView.allowsFocus = false
        self.tableView.allowsSelection = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = indexPath.row
        let cell = HostingCell<Row>()
        cell.set(rootView:  content(data[index]), parentController: self)
        cell.clipsToBounds = true
        return cell
        
    }
}


//struct FeedView<Data, Row: View> : UIViewControllerRepresentable{
//
//     let content: (Data) -> Row
//     let data: [Data]
//    var controller = UITableViewController()
//
//    init(_ data: [Data], _ content: @escaping (Data) -> Row ,controller : UITableViewController = UITableViewController()) {
//        self.data = data
//        self.content = content
//        self.controller = controller
//    }
////
////    func makeUIView(context: Context) -> UITableView {
////        let tableview = UITableView(frame: .zero, style: .plain)
////        tableview.delegate = context.coordinator
////        tableview.dataSource = context.coordinator
////        tableview.separatorStyle = .none
////        return tableview
////    }
////    func updateUIView(_ uiView: UITableView, context: Context) {
////        context.coordinator.data = data
////        uiView.reloadData()
////    }
//
//    func makeUIViewController(context:Context) -> some UITableViewController {
//        let tableview = UITableView(frame: .zero, style: .plain)
//        tableview.delegate = context.coordinator
//        tableview.dataSource = context.coordinator
//        tableview.separatorStyle = .none
//        controller.tableView = tableview
//        return controller
//    }
//    func updateUIViewController(_ uiViewController: UITableViewController, context:Context) {
//        context.coordinator.data = data
//        uiViewController.tableView.reloadData()
//    }
//
////    func makeUIViewController(context: Context) -> some UIViewController {
////        return controller
////    }
////    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
////
////    }
//    func makeCoordinator() -> Coordinator {
//        Coordinator(data, content, partent: self)
//    }
//
//    class Coordinator: NSObject, UITableViewDataSource, UITableViewDelegate {
//
//        let content: (Data) -> Row
//        var data: [Data]
//        let partent : FeedView
//
//        init(_ data: [Data], _ content: @escaping (Data) -> Row,partent:FeedView) {
//            self.data = data
//            self.content = content
//            self.partent = partent
//        }
//
//        //项目个数
//        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            data.count
//        }
//
//        //生成元素
//        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            let index = indexPath.row
//            let cell = tableView.cellForRow(at: indexPath) as! HostingCell<Row>
//            cell.set(rootView:  content(data[index]), parentController: self.partent.controller)
//            return cell
//        }
//    }
//
//
//
//
//}


//class Coordinator: NSObject, UITableViewDataSource, UITableViewDelegate {
//
//    let content: (Data) -> Row
//    var data: [Data]
//    let partent : FeedView
//
//    init(_ data: [Data], _ content: @escaping (Data) -> Row,partent:FeedView) {
//        self.data = data
//        self.content = content
//        self.partent = partent
//    }
//
//    //项目个数
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        data.count
//    }
//
//    //生成元素
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////            let index = indexPath.row
//        let cell = tableView.cellForRow(at: indexPath) as! HostingCell<Row>
//        cell.set(rootView: Text("322"), parentController: self.partent.controller)
//        return cell
//    }
//}
//func makeCoordinator() -> Coordinator {
//    Coordinator(data, content,partent: self)
//}

struct TestTest : View{
    
    var body: some View{
        NavigationView {
            Group {
                if  let arr = MockTool.readArray(Post.self, fileName: "timelinedata", atKeyPath: "statuses"){
                    PF_SelfSizingView(arr) { data in
                        withAnimation(.spring()){
                            TweetCard(post: data)
                                .id(data.text!)
                        }
                    }
                    .ignoresSafeArea()
                }else{
                    ProgressView()
                }
            }
            //            .ignoresSafeArea()
            .navigationBarTitleDisplayMode(.inline)
        }
        
        
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        TestTest()
    }
}


struct PF_SelfSizingView<Data ,Row : View> : UIViewControllerRepresentable{
    
    var content: (Data) -> Row
    var data: [Data]
    let con : TableViewController<Data, Row>
    
    init(_ data: [Data], _ content: @escaping (_ data : Data) -> Row) {
        self.data = data
        self.content = content
        self.con = TableViewController(style: .grouped, data , content)
    }
    
    func makeUIViewController(context: Context) -> UITableViewController {
        return con
    }
    func updateUIViewController(_ uiViewController: UITableViewController, context: Context) {
        con.tableView.reloadData()
    }
}



final class HostingCell<Content: View>: UITableViewCell {
    private let hostingController = UIHostingController<Content?>(rootView: nil)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        hostingController.view.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(rootView: Content, parentController: UIViewController) {
        self.hostingController.view.invalidateIntrinsicContentSize()
        self.hostingController.rootView = rootView
        
        
        let requiresControllerMove = hostingController.parent != parentController
        if requiresControllerMove {
            parentController.addChild(hostingController)
        }
        
        if !self.contentView.subviews.contains(hostingController.view) {
            self.contentView.addSubview(hostingController.view)
            hostingController.view.translatesAutoresizingMaskIntoConstraints = false
            hostingController.view.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
            hostingController.view.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
            hostingController.view.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
            hostingController.view.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        }
        
        if requiresControllerMove {
            hostingController.didMove(toParent: parentController)
        }
    }
}


