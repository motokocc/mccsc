import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Debug "mo:base/Debug";

shared(msg) actor class Game(_owner: Principal, _name: Text) {

    private stable var sName : Text = _name;
    private stable var sOwner : Principal = _owner;

	public type ServerResult = {
		user: Principal;
		score: Int;
	};


    public type ControllerActor = actor {
        allow: (user: Principal) -> async Bool;
        result: (result: [ServerResult]) -> async ();
    };

    private let controller_actor : ControllerActor = actor(Principal.toText(sOwner));

    public shared(msg) func test(): async Text{
        let allow = await controller_actor.allow(msg.caller);
        if(allow){
            return "Hello, allow" # sName # "!";
        }else{
            return "Hello, " # sName # "!";
        }
    };
}
