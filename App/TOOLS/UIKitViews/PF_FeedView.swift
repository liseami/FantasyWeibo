//
//  FeedView.swift
//  FantasyWeibo (iOS)
//
//  Created by 赵翔宇 on 2022/1/22.
//

import SwiftUI
import SDWebImageSwiftUI

enum refreshResult{
    case success
    case error
}

struct PF_FeedView<Data ,Row : View> : UIViewControllerRepresentable{
    
    var controller = UITableViewController()
    @Binding var reload : Bool
    @Binding var data: [Data]
    let content: (_ someitem :Data) -> Row
    var refreshAction : () -> ()
    //
    init(_ reload : Binding<Bool>,  _ data: Binding<[Data]>, _ content: @escaping (_ someitem :Data) -> Row,refreshAction : @escaping () -> () = {}){
        _data = data
        _reload = reload
        self.content = content
        self.refreshAction = refreshAction
    }

    func makeUIViewController(context:Context) ->  UITableViewController {
        let tableview = UITableView(frame: .zero, style: .plain)
     
        //刷新控件
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(context.coordinator, action: #selector(Coordinator.handleRefreshControl), for: .valueChanged)
        
        
        //UITableView
        tableview.delegate = context.coordinator
        tableview.dataSource = context.coordinator
        tableview.separatorStyle = .none
        tableview.allowsSelection = false
        tableview.allowsFocus = false
        tableview.addSubview(refreshControl)
        
        
        self.controller.tableView = tableview
        return self.controller
    }
    
    
   
    func updateUIViewController(_ uiViewController: UITableViewController, context:Context) {
        if reload{
            DispatchQueue.main.async {
                uiViewController.tableView.reloadData()
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(partent: self)
    }
    
    class Coordinator: NSObject, UITableViewDataSource, UITableViewDelegate {
        
        let partent : PF_FeedView
        
        init(partent:PF_FeedView) {
            self.partent = partent
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            1
        }
        //项目个数
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            partent.data.count
        }
        
        //生成元素
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let index = indexPath.row
            let cell = HostingCell<Row>()
            cell.set(rootView:  partent.content(partent.data[index]), parentController: partent.controller)
            cell.clipsToBounds = true
            return cell
        }
        
        @objc func handleRefreshControl(sender: UIRefreshControl) {
                 // handle the refresh event
            partent.refreshAction()
            sender.endRefreshing()
            
             }
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


struct TestTest : View{
    
    @State private var posts : [Post] = []
    @State private var reload : Bool = false
    var body: some View{
        
        NavigationView {
            Group {
           
              
                PF_FeedView($reload, $posts, { post in
                    TweetCard(post: post)
                }, refreshAction: {
                    posts = MockTool.readArray(Post.self, fileName: "timelinedata", atKeyPath: "statuses")!
                    sleep(2)
                })
                             .ignoresSafeArea()
                
           
                
            }
            .overlay(Text("\(posts.count)"))
            .onAppear(perform: {
                posts = MockTool.readArray(Post.self, fileName: "timelinedata", atKeyPath: "statuses")!
                reload.toggle()
            })
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



//class TableViewController<Data ,Row : View>: UITableViewController {
//
//
//    var content: (Data) -> Row
//    var data: [Data]
//
//    init(style: UITableView.Style,_ data: [Data], _ content: @escaping (_ data : Data) -> Row) {
//        self.data = data
//        self.content = content
//        super.init(style: style)
//        self.tableView.register(HostingCell<Row>.self, forCellReuseIdentifier: "tweet")
//
//        self.tableView.separatorStyle = .none
//        self.tableView.rowHeight = UITableView.automaticDimension
//        self.tableView.estimatedRowHeight = 300
//        self.tableView.backgroundColor = UIColor(Color.BackGround)
//        self.tableView.allowsFocus = false
//        self.tableView.allowsSelection = false
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return data.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let index = indexPath.row
//        let cell = HostingCell<Row>()
//        cell.set(rootView:  content(data[index]), parentController: self)
//        cell.clipsToBounds = true
//        return cell
//
//    }
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



//struct PF_FeedView<Data ,Row : View> : UIViewControllerRepresentable{
//
//    var content: (Data) -> Row
//    var data: [Data]
//    let con : TableViewController<Data, Row>
//
//    init(_ data: [Data], _ content: @escaping (_ data : Data) -> Row) {
//        self.data = data
//        self.content = content
//        self.con = TableViewController(style: .grouped, data , content)
//    }
//
//    func makeUIViewController(context: Context) -> UITableViewController {
//        return con
//    }
//    func updateUIViewController(_ uiViewController: UITableViewController, context: Context) {
//        uiViewController.reloadInputViews()
//        uiViewController.tableView.reloadData()
//    }
//}


