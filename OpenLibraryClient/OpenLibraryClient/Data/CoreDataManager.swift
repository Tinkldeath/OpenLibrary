import Foundation
import CoreData


protocol ImageCacheProtocol {
    func cache(_ cover: Int, _ image: Data?)
    func findInCache(_ cover: Int) -> Data?
}

final class CoreDataManager {
    
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
    
    public static var shared = {
        return _instance
    }()
    
    private static var _instance = CoreDataManager()
    
    private init() {}
    
}


extension CoreDataManager: ImageCacheProtocol {
    
    func cache(_ cover: Int, _ image: Data?) {
        do {
            self.manageCache()
            if let cached = try self.persistentContainer.viewContext.fetch(CachedImage.fetchRequest()).first(where: { $0.cover == Int64(cover) }) {
                cached.image = image
                self.saveContext()
            } else {
                guard image != nil else { return }
                let cached = CachedImage(context: self.persistentContainer.viewContext)
                cached.cover = Int64(cover)
                cached.image = image
                self.saveContext()
            }
        } catch {
            print(String(describing: error))
        }
    }
    
    func findInCache(_ cover: Int) -> Data? {
        do {
            if let cached = try self.persistentContainer.viewContext.fetch(CachedImage.fetchRequest()).first(where: { $0.cover == Int64(cover) }) {
                return cached.image
            }
        } catch {
            print(String(describing: error))
        }
        return nil
    }
        
    private func manageCache() {
        DispatchQueue.global(qos: .utility).async {
            let cahed = try? self.persistentContainer.viewContext.fetch(CachedImage.fetchRequest())
            guard cahed != nil else { return }
            let count = cahed!.count
            if count > 1000 {
                cahed!.forEach { value in
                    DispatchQueue.main.async {
                            self.persistentContainer.viewContext.delete(value)
                        }
                    }
                DispatchQueue.main.async {
                    self.saveContext()
                }
            }
        }
    }
    
}
