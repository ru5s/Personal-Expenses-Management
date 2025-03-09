//
//  CoreData.swift
//  Flux Zenithy
//
//  Created by Den on 29/03/24.
//

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let container: NSPersistentCloudKitContainer = {
        return NSPersistentCloudKitContainer(name: "Flux_Zenithy")
    }()
    
    init(inMemory: Bool = false) {
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores { storeDescription, err in
            if let err = err {
                fatalError(err.localizedDescription)
            }
        }
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Unable to access document directory")
        }
        let dbUrl = documentDirectory.appendingPathComponent("Flux_Zenithy")
        print("Path to database: \(dbUrl.path)")
    }
    
    func save() throws {
        let context = container.viewContext
        if context.hasChanges {
            try context.save()
        }
    }
    
    func saveItem(name: String, cost: String) {
        let item = Item(context: container.viewContext)
        item.id = UUID()
        item.name = name
        item.cost = cost

        try? save()
    }
    
    func removeItemFromCoreData(id: UUID) {
        if let findItem = searchItem(forUUID: id) {
            let context = container.viewContext
            context.delete(findItem)
            try? save()
        }
    }
    func searchItem (forUUID uuid: UUID) -> Item? {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
        do {
            let results = try container.viewContext.fetch(fetchRequest)
            return results.first
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
            return nil
        }
    }
    func removeAll() {
            print("erase data from Investment")
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Item")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try container.viewContext.execute(batchDeleteRequest)
            } catch {
                print("Error deleting data: \(error.localizedDescription)")
            }
        }
}
