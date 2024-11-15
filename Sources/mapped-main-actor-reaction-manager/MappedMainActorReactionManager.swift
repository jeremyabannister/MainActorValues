//
//  MappedMainActorReactionManager.swift
//  
//
//  Created by Jeremy Bannister on 2/11/23.
//

///
@_exported import MainActorValues_interface_main_actor_reaction_manager


///
extension Interface_MainActorReactionManager {
    
    ///
    public func map<
        NewEvent
    >(
        _ transform: @escaping @MainActor (Event)->NewEvent
    ) -> MappedMainActorReactionManager<Event, NewEvent> {
        
        ///
        .init(
            base: self,
            transform: transform
        )
    }
}


///
public struct MappedMainActorReactionManager<UpstreamEvent, Event>: Interface_MainActorReactionManager {
    
    ///
    fileprivate init(
        base: some Interface_MainActorReactionManager<UpstreamEvent>,
        transform: @escaping @MainActor (UpstreamEvent)->Event
    ) {
        
        self.base = base
        self.transform = transform
    }
    
    ///
    private let base: any Interface_MainActorReactionManager<UpstreamEvent>
    
    ///
    private let transform: @MainActor (UpstreamEvent)->Event
    
    ///
    public func _registerReaction_weakClosure(
        key: String,
        _ reaction: @escaping @MainActor (Event)->()
    ) -> @MainActor ()->() {
        
        ///
        base._registerReaction_weakClosure(key: key) { [transform] in
            reaction(transform($0))
        }
    }
    
    ///
    public func _unregisterReaction_weakClosure(
        forKey key: String
    ) -> @MainActor ()->() {
        
        ///
        base._unregisterReaction_weakClosure(forKey: key)
    }
    
    ///
    public var leakTracker: LeakTracker {
        base.leakTracker
    }
}
