import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseDatabaseInternal

/// Enum RealtimeDatabaseFirebaseModuleError
/// Hanlde error of Realtime Database Firebase
public enum RealtimeDatabaseFirebaseModuleError: Error {
    case invalidPath

    var localizedDescription: String {
        switch self {
        case .invalidPath:
            return "invalid path of database"
        }
    }
}

public enum Result<T, Error> {
    case success(T)
    case failure(Error)
}

// MARK: protocol RealtimeDatabaseFirebaseModuleProtocol
/// protocol RealtimeDatabaseFirebaseModuleProtocol
/// list of functions for Realtime database
protocol RealtimeDatabaseFirebaseModuleProtocol {
    /// configure somthing to Realtime database Firebase
    func configure()
    
    /// create new child node to database or update value to child node
    /// - parameter value: the value of child node which will added/ updated
    /// - parameter child: child node which will be added/ updated value
    /// - parameter parentNodes: the list of parents node of child node as list of string. Example: parent1, parent2, parent3,....
    /// - parameter completion: the call back result with format (Error?). It means adding/ updating value to child node is success if we don't have any errors
    func set(_ value: Any, at child: String, parentNodes: String..., completion: @escaping RealtimeDatabaseFirebaseModule.ErrorCompletion)
    
    /// create new child node to database or update value to child node
    /// - parameter value: the value of child node which will added/ updated
    /// - parameter child: child node which will be added/ updated value
    /// - parameter parentNodes: the list of parents node of child node as string array. Example: [parent1, parent2, parent3,....]
    /// - parameter completion: the call back result with format (Error?). It means adding/ updating value to child node is success if we don't have any errors
    func set(_ value: Any, at child: String, parentNodes: [String], completion: @escaping RealtimeDatabaseFirebaseModule.ErrorCompletion)
    
    /// get value of child node from database
    /// - parameter child: the child node what will be get the value
    /// - parameter parentNodes: the list of parents node of child node as list of string. Example: parent1, parent2, parent3,....
    /// - parameter completion: the call back result with format (Result<DataSnapshot, Error>)
    func get(at child: String, parentNodes: String..., completion: @escaping RealtimeDatabaseFirebaseModule.DataCompletion)
    
    /// get value of child node from database
    /// - parameter child: the child node what will be get the value
    /// - parameter parentNodes: the list of parents node of child node as string array. Example: [parent1, parent2, parent3,....]
    /// - parameter completion: the call back result with format (Result<DataSnapshot, Error>)
    func get(at child: String, parentNodes: [String], completion: @escaping RealtimeDatabaseFirebaseModule.DataCompletion)
    
    /// delete child node from database
    /// - parameter child: the child node what will be deleted from database
    /// - parameter parentNodes: the list of parents node of child node as list of string. Example: parent1, parent2, parent3,....
    /// - parameter completion: the call back result with format (Error?). It means deleting child node is success if we don't have any errors
    func delete(at child: String, parentNodes: String..., completion: @escaping RealtimeDatabaseFirebaseModule.ErrorCompletion)
    
    /// delete child node from database
    /// - parameter child: the child node what will be deleted from database
    /// - parameter parentNodes: the list of parents node of child node as string array. Example: [parent1, parent2, parent3,....]
    /// - parameter completion: the call back result with format (Error?). It means deleting child node is success if we don't have any errors
    func delete(at child: String, parentNodes: [String], completion: @escaping RealtimeDatabaseFirebaseModule.ErrorCompletion)
}

// MARK: /// class RealtimeDatabaseFirebaseModule
/// class RealtimeDatabaseFirebaseModule
public class RealtimeDatabaseFirebaseModule: RealtimeDatabaseFirebaseModuleProtocol {
    typealias DataCompletion = (Result<String?, Error>) -> Void
    typealias ErrorCompletion = (Error?) -> Void
    
    /// a shared instance of RealtimeDatabaseFirebaseModule as singleton instance
    static let sharedInstance = RealtimeDatabaseFirebaseModule()
    private var refDB: DatabaseReference!

    func configure() {
//        FirebaseApp.configure()
        refDB = Database.database().reference()
    }

    func set(_ value: Any, at child: String, parentNodes: String..., completion: @escaping RealtimeDatabaseFirebaseModule.ErrorCompletion) {
        set(value, at: child, parentNodes: parentNodes, completion: completion)
    }

    func get(at child: String, parentNodes: String..., completion: @escaping RealtimeDatabaseFirebaseModule.DataCompletion) {
        get(at: child, parentNodes: parentNodes, completion: completion)
    }
    
    func delete(at child: String, parentNodes: String..., completion: @escaping RealtimeDatabaseFirebaseModule.ErrorCompletion) {
        delete(at: child, parentNodes: parentNodes, completion: completion)
    }

    func set(_ value: Any, at child: String, parentNodes: [String], completion: @escaping RealtimeDatabaseFirebaseModule.ErrorCompletion) {
        do {
            try makeReference(child: child, parentNodes: parentNodes).setValue(value) { (error, _) in
                completion(error)
            }
        } catch {
            completion(error)
        }
    }
    
    func get(at child: String, parentNodes: [String], completion: @escaping RealtimeDatabaseFirebaseModule.DataCompletion) {
        do {
            try makeReference(child: child, parentNodes: parentNodes).observeSingleEvent(of: .value) { (data) in
                completion(.success(data.json))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func delete(at child: String, parentNodes: [String], completion: @escaping RealtimeDatabaseFirebaseModule.ErrorCompletion) {
        do {
            try makeReference(child: child, parentNodes: parentNodes).removeValue { (error, _) in
                completion(error)
            }
        } catch {
            completion(error)
        }
    }
    
    // MARK: private functions
    
    /// generate the path of parent nodes with child node
    /// - parameter child: the child node
    /// - parameter parentNodes: the list of parents node of child node as list of string. Example: parent1, parent2, parent3,....
    /// - throws: Throw an error as RealtimeDatabaseFirebaseModuleError.invalidPath if we can't generate a path
    /// - returns : a string as "Parent Node1/ Parent Node2/ Parent Node3/ ..../ Child Node"
    private func makeReference(child: String, parentNodes: String...) throws -> DatabaseReference {
        return try makeReference(child: child, parentNodes: parentNodes)
    }

    /// generate the path of parent nodes with child node
    /// - parameter child: the child node
    /// - parameter parentNodes: the list of parents node of child node as string array. Example: [parent1, parent2, parent3,....]
    /// - throws: Throw an error as RealtimeDatabaseFirebaseModuleError.invalidPath if we can't generate a path
    /// - returns : a path as "Parent Node1/ Parent Node2/ Parent Node3/ ..../ Child Node"
    private func makeReference(child: String, parentNodes: [String]) throws -> DatabaseReference {
        do {
            return try refDB.child(String.makePath(child: child, parentNodes: parentNodes))
        } catch {
            throw error
        }
    }
}
