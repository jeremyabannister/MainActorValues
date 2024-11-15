//
//  MainActorValueBinding.swift
//  
//
//  Created by Jeremy Bannister on 9/14/23.
//

///
@_exported import MainActorValues_interface_main_actor_value_binding


///
@MainActor
public struct MainActorValueBinding<Value>: Interface_MainActorValueBinding {
    
    ///
    public init(
        get: @escaping @MainActor ()->Value,
        set: @escaping @MainActor (Value)->()
    ) {
        
        ///
        self.get = get
        self.set = set
    }
    
    ///
    private let get: @MainActor ()->Value
    private let set: @MainActor (Value)->()
    
    ///
    public var currentValue: Value {
        get { get() }
        nonmutating set { set(newValue) }
    }
}
