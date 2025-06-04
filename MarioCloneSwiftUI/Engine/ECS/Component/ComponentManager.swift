import SwiftUI

class ComponentManager {
//    Each component has a single entry in the dict, where the
//    value is a dict of Entity IDs, and the component value itself
    private var storage: [ObjectIdentifier: [UUID: Any]] = [:]
    
    func entitiesWith(allOf componentTypes: [Any.Type]) -> [Entity] {
        guard !componentTypes.isEmpty else { return [] }
        
        let idSets: [Set<UUID>] = componentTypes.compactMap { componentType in
            let key = ObjectIdentifier(componentType)
            
            return storage[key].map { Set($0.keys) }
        }
        
        guard idSets.count == componentTypes.count else { return [] }
        
        let commonIDs = idSets.reduce(idSets[0]) { $0.intersection($1) }

        return commonIDs.map { Entity(id: $0) }
    }
    
    func add<TComponent>(_ component: TComponent, to entity: Entity) {
        let componentKey = ObjectIdentifier(TComponent.self)
        
        var entityComponentMap = storage[componentKey] ?? [:]
        entityComponentMap[entity.id] = component
        
        storage[componentKey] = entityComponentMap
    }
    
    func getById<TComponent>(_ type: TComponent.Type, for id: UUID) -> TComponent? {
        let key = ObjectIdentifier(TComponent.self)
        
        return storage[key]?[id] as? TComponent
    }
    
    func get<TComponent>(_ type: TComponent.Type, for entity: Entity) -> TComponent? {
        getById(type, for: entity.id)
    }
}
