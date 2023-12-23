import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseDatabaseInternal

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

protocol RealtimeDatabaseFirebaseModuleProtocol {
    func configure()
    func set(_ value: Any, at child: String, parentNodes: String..., completion: @escaping RealtimeDatabaseFirebaseModule.ErrorCallback)
    func get(at child: String, parentNodes: String..., completion: @escaping RealtimeDatabaseFirebaseModule.DataCallback)
    func get(at child: String, parentNodes: [String], completion: @escaping RealtimeDatabaseFirebaseModule.DataCallback)
    func delete(at child: String, parentNodes: String..., completion: @escaping RealtimeDatabaseFirebaseModule.ErrorCallback)
}

public class RealtimeDatabaseFirebaseModule: RealtimeDatabaseFirebaseModuleProtocol {
    typealias DataCallback = (Result<DataSnapshot, Error>) -> Void
    typealias ErrorCallback = (Error?) -> Void
    
    static let sharedInstance = RealtimeDatabaseFirebaseModule()
    private var refDB: DatabaseReference!

    func configure() {
//        FirebaseApp.configure()
        refDB = Database.database().reference()
    }

    func set(_ value: Any, at child: String, parentNodes: String..., completion: @escaping RealtimeDatabaseFirebaseModule.ErrorCallback) {
        set(value, at: child, parentNodes: parentNodes, completion: completion)
    }

    func get(at child: String, parentNodes: String..., completion: @escaping RealtimeDatabaseFirebaseModule.DataCallback) {
        get(at: child, parentNodes: parentNodes, completion: completion)
    }
    
    func delete(at child: String, parentNodes: String..., completion: @escaping RealtimeDatabaseFirebaseModule.ErrorCallback) {
        delete(at: child, parentNodes: parentNodes, completion: completion)
    }

    // MARK: Private Functions
    func set(_ value: Any, at child: String, parentNodes: [String], completion: @escaping RealtimeDatabaseFirebaseModule.ErrorCallback) {
        do {
            try makeReference(child: child, parentNodes: parentNodes).setValue(value) { (error, _) in
                completion(error)
            }
        } catch {
            completion(error)
        }
    }
    
    func get(at child: String, parentNodes: [String], completion: @escaping RealtimeDatabaseFirebaseModule.DataCallback) {
        do {
            try makeReference(child: child, parentNodes: parentNodes).observeSingleEvent(of: .value) { (data) in
                completion(.success(data))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func delete(at child: String, parentNodes: [String], completion: @escaping RealtimeDatabaseFirebaseModule.ErrorCallback) {
        do {
            try makeReference(child: child, parentNodes: parentNodes).removeValue { (error, _) in
                completion(error)
            }
        } catch {
            completion(error)
        }
    }
    
    //
    private func makeReference(child: String, parentNodes: String...) throws -> DatabaseReference {
        return try makeReference(child: child, parentNodes: parentNodes)
    }

    private func makeReference(child: String, parentNodes: [String]) throws -> DatabaseReference {
        do {
            return try refDB.child(String.makePath(child: child, parentNodes: parentNodes))
        } catch {
            throw error
        }
    }
}
