//
//  MockTool.swift
//  Motion
//
//  Created by 梁泽 on 2021/10/12.
//


import Foundation


struct MockTool {
    
    static func jsonForFile(_ fileName: String) -> JSON? {
        
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json"){
            if let data = try? Data(contentsOf: url) {
                return try? JSON(data: data)
            }else{
            print("Mook____文件url转Data失败")
            return nil
            }
        }else{
            print("Mook____文件url解析失败")
            return nil
        }
     
        
    }
 
    static func readObject<T: Convertible>(_ type: T.Type, fileName: String, atKeyPath keyPath: String? = nil) -> T? {
        let json =  jsonForFile(fileName)
        
        if let keyPath = keyPath {
            guard let originDic = (json?.dictionaryObject as NSDictionary?)?.value(forKeyPath: keyPath) else {
                print("Mook...readObject...JSONdictionaryObject 失败")
                return nil
            }
            
            return JSON(originDic).dictionaryObject?.kj.model(T.self)
        }
        
        return json?.dictionaryObject?.kj.model(T.self)
    }
    
    static func readObjectNoKeyPath<T: Convertible>(_ type: T.Type, fileName: String) -> T? {
        let json =  jsonForFile(fileName)
        
        return json?.dictionaryObject?.kj.model(T.self)
        
    }
    
    static func readArray<T: Convertible>(_ type: T.Type, fileName: String, atKeyPath keyPath: String? = nil) -> [T]? {
        let json =  jsonForFile(fileName)

        if let keyPath = keyPath {
            guard let originDic = (json?.dictionaryObject as NSDictionary?)?.value(forKeyPath: keyPath) else {
                print("Mook...readArray...JSONdictionaryObject 失败")
                return nil
            }
            
            return JSON(originDic).arrayObject?.kj.modelArray(T.self)
        }
        
        return json?.arrayObject?.kj.modelArray(T.self)
    }
    
    
    /// 示例
    static func using() {
//        let arr = MockTool.readArray(LangModel.self, fileName: "codepower_langs")
        print("")
    }
}
