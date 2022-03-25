
import Principal "mo:base/Principal";

module{
    public type ServerResult = {
        user: Principal;
        score: Int;
	};
    
    public type ControllerActor = actor {
        allow: (user: Principal) -> async Bool;
        result: (result: [ServerResult]) -> async [Principal];
    };
}