import Foundation
import CoreData


protocol ImageCacheProtocol {
    func cache(_ cover: Int, _ image: Data?)
    func findInCache(_ cover: Int) -> Data?
}

final class CoreDataManager {
    
    private lazy var items = {
        let items = try! self.persistentContainer.viewContext.fetch(CachedImage.fetchRequest()).lazy.count
        return items
    }()
    
    // MARK: - Core Data stack
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "OpenLibraryClient")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    private func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - SINGLETON
    public static var shared = {
        return _instance
    }()
    
    private static var _instance = CoreDataManager()
    private init() {}
    
}


extension CoreDataManager: ImageCacheProtocol {
    
    // MARK: - THREAD SAFE METHODS FOR CACHING IMAGES
    func cache(_ cover: Int, _ image: Data?) {
        self.manageCache()
        let cached = try! self.persistentContainer.viewContext.fetch(CachedImage.fetchRequest()).first(where: { $0.cover == Int64(cover) })
        guard cached == nil else { return }
        DispatchQueue.main.async {
            let item = CachedImage(context: self.persistentContainer.viewContext)
            item.cover = Int64(cover)
            item.image = image
            self.saveContext()
        }
    }
    
    func findInCache(_ cover: Int) -> Data? {
        return try! self.persistentContainer.viewContext.fetch(CachedImage.fetchRequest()).first(where: { $0.cover == Int64(cover) })?.image
    }
        
    private func manageCache() {
        DispatchQueue.global(qos: .utility).async {
            guard self.items > 1000 else { return }
            self.clearImages()
        }
    }
    
    private func clearImages() {
        DispatchQueue.main.async {
            try! self.persistentContainer.viewContext.fetch(CachedImage.fetchRequest()).lazy.forEach { image in
                self.persistentContainer.viewContext.delete(image)
            }
            self.saveContext()
        }
    }
    
}
