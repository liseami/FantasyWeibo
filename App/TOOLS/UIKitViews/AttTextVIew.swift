import SwiftUI
import AttributedTextView

struct NativeTextsWithManagedHeight: View {
    let rows = Array(repeating: randomString(50),count: 120)
    var body: some View {

        ScrollViewReader { scrollViewProxy in
            VStack {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(0..<120, id: \.self) { i in
                            PF_TextArea(text: "//@吃不胖的小5:艹//@段子楼:条件反射了属于是//@太皇太后您有喜啦:[允悲]//@万事屋纸纸酱:哈哈哈哈哈哈哈哈哈哈哈哈哈草//@勿祈：哈哈哈哈#哈哈哈哈哈哈哈 //@霆洲今天又惹老婆生气了吗:哈哈哈哈哈哈哈哈我笑到同事抄起键盘追杀我")
                                .padding()
                        }
                    }
                }
                Button("Scroll to row 3") {
                    print("Something")
                    withAnimation {
                        scrollViewProxy.scrollTo("Hello https://example.com: 1 2 3", anchor: .center)
                    }
                }.padding()
            }
        }

    }

}
struct NativeTextsWithManagedHeight_Previews: PreviewProvider {
    static var previews: some View {
        NativeTextsWithManagedHeight()
    }
}
#if os(iOS)
typealias NativeFont = UIFont
typealias NativeColor = UIColor


struct NativeTextView: UIViewRepresentable {
    let text: String
    var font : UIFont = MFont(style: .Title_16_R).returnUIFont()

    func makeUIView(context: Context) -> AttributedTextView {

        let textView = AttributedTextView()
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.dataDetectorTypes = .link
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textView.textContainer.lineFragmentPadding = 0
        textView.backgroundColor = UIColor(.clear)

        textView
            .attributer  = text
//            .color(UIColor(.fc1))
            .font(font)
            .paragraphLineSpacing(4)
            .paragraphApplyStyling

            .matchshorturl
            .color(UIColor(.red))

            .matchHashtags
            .color(UIColor(.green))

            .matchMentions
            .makeInteract({ link in
                print(link)
            })







        return textView
    }
    func updateUIView(_ textView: AttributedTextView, context: Context) {
    }
}

extension Attributer{
    open var matchshorturl : Attributer {
        get {
            return matchPattern( #"https{0,1}://t.cn/[A-Z0-9a-z]{6,8}[/]{0,1}"#)
        }
    }
}

#endif
func attributedString(for string: String,font:UIFont = MFont(style: .Title_16_R).returnUIFont()) -> NSAttributedString {
    let attributedString = NSMutableAttributedString(string: string)
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 4
    let range = NSMakeRange(0, (string as NSString).length)
    attributedString.addAttribute(.font, value: font, range: range)
    attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
    return attributedString
}
extension NSAttributedString {
    func height(containerWidth: CGFloat) -> CGFloat {
        let rect = self.boundingRect(with: CGSize.init(width: containerWidth, height: CGFloat.greatestFiniteMagnitude),
                                     options: [.usesLineFragmentOrigin, .usesFontLeading],
                                     context: nil)
        return ceil(rect.size.height)
    }
}

func texts(count: Int) -> [String] {
    return (1...count).map {
        (1...$0).reduce("Hello https://example.com:", { $0 + " " + String($1) })
    }
}


public func PF_MakeTextArea(_ w : CGFloat = SW * 0.86 - 24 - 16 - 12, text: String,font : UIFont = UIFont(name: "MiSans-Semibold", size: 16)!) -> some View {
    let attributed = attributedString(for: text)
    let height = attributed.height(containerWidth:w)
    return NativeTextView(text: text,font:font).frame(width: w, height: height).id(text)
}

struct PF_TextArea : View{

    @State private var w : CGFloat = 0
    let text : String
    var font : UIFont = MFont(style: .Title_16_R).returnUIFont()

    var body: some View{

        ZStack{
            GeometryReader { geo  in
                Rectangle().foregroundColor(.clear)
                    .onAppear {
                        guard w == 0 else {return}
                        let w = geo.frame(in: .global).size.width
                        self.w = w
                    }
            }
            let attributed = attributedString(for: text,font: font)
            let height = attributed.height(containerWidth:w)
            NativeTextView(text: text,font:font)
                .frame(width: w, height: height)
                .id(text.hashValue)
        }
    }
}
