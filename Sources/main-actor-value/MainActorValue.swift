//
//  MainActorValue.swift
//  
//
//  Created by Jeremy Bannister on 2/12/23.
//

///
@_exported import MainActorValues_interface_readable_main_actor_value


///
@MainActor
public struct MainActorValue<Value>: Interface_ReadableMainActorValue {
    
    ///
    public nonisolated init(_ fetchValue: @escaping @MainActor ()->Value) {
        self.fetchValue = fetchValue
    }
    
    ///
    private nonisolated let fetchValue: @MainActor ()->Value
    
    ///
    public var currentValue: Value {
        fetchValue()
    }
}
