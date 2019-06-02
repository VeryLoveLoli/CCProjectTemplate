# Prompt
`Swift` `iOS` `Prompt`

* 文字提示
* 加载提示
* GIF提示

## Usage

### Initialization

```swift
    /**
     文字提示
     
     - parameter    title:          文字
     - parameter    milliseconds:   显示时间
     - parameter    isBackground:   是否显示背景（用于阻止用户点击）
     - parameter    sup:            添加到的视图
     - parameter    location:       在视图中的位置
     */
    public static func title(_ title: String, milliseconds: Int, isBackground: Bool, sup: UIView, location: CGPoint)
    
    /**
     窗口文字提示
     
     - parameter    title:          文字
     - parameter    milliseconds:   显示时间
     - parameter    isBackground:   是否显示背景（用于阻止用户点击）
     */
    static func titleWindow(_ title: String, milliseconds: Int, isBackground: Bool)
    
    /**
     加载提示
     
     - parameter    title:          文字
     - parameter    timeInterval:   动态显示的文字时间间隔
     - parameter    repeats:        动态显示的文字个数（<=title.count，从后往前算）
     - parameter    isBackground:   是否显示背景（用于阻止用户点击）
     - parameter    sup:            添加到的视图
     - parameter    location:       在视图中的位置
     */
    public static func load(_ title: String, timeInterval: TimeInterval, repeats: Int, isBackground: Bool, sup: UIView, location: CGPoint) -> Prompt
    
    /**
     窗口加载提示
     
     - parameter    title:          文字
     - parameter    timeInterval:   动态显示的文字时间间隔
     - parameter    repeats:        动态显示的文字个数（<=title.count，从后往前算）
     - parameter    isBackground:   是否显示背景（用于阻止用户点击）
     */
    static func loadWindow(_ title: String, timeInterval: TimeInterval, repeats: Int, isBackground: Bool) -> Prompt?
    
    /**
     GIF提示
     
     - parameter    data:           GIF数据
     - parameter    isBackground:   是否显示背景（用于阻止用户点击）
     - parameter    sup:            添加到的视图
     - parameter    location:       在视图中的位置
     */
    public static func gif(_ data: Data, isBackground: Bool, sup: UIView, location: CGPoint) -> Prompt
    
    /**
     窗口GIF提示
     
     - parameter    data:           GIF数据
     - parameter    isBackground:   是否显示背景（用于阻止用户点击）
     */
    static func gifWindow(_ data: Data, isBackground: Bool) -> Prompt?
```

```swift

    /// 文字提示
    Prompt.title("呵呵", milliseconds: 2000, isBackground: true, sup: view, location: view.center)
        
    /// 加载提示
    let load = Prompt.load("正在加载...", timeInterval: 1, repeats: 2, isBackground: true, sup: view, location: view.center)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10)) {
    
        load.close()
    }
    	
    /// GIF提示
    if let path = Bundle.main.path(forResource: "test", ofType: "gif") {
        
        do {
            
            let data = try Data.init(contentsOf: URL.init(fileURLWithPath: path))
            let gif = Prompt.gif(data, isBackground: true, sup: view, location: view.center)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10)) {
                
                gif.close()
            }
            
        } catch {
            
            print(error)
        }
    }
```