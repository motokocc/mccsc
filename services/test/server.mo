import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Debug "mo:base/Debug";
import Hash "mo:base/Hash";

shared(msg) actor class Server(_owner: Principal, _name: Text) {

    private stable var s_name : Text = _name;
    private stable var s_owner : Principal = _owner;
    
    public type UserData = Int;

    public type ServiceData = {
        user: Principal;
        data: UserData;
	};

    public type ControllerActor = actor {
        bind: (_server: Principal) -> async ();
        allow: (_user: Principal) -> async Bool;
        update: (result: [ServiceData]) -> async ();
    };
 
    private let controller_actor : ControllerActor = actor(Principal.toText(s_owner));

   
    // 业务开始
    public shared(msg) func start(): async Text{
        let allow = await controller_actor.allow(msg.caller);
        if(allow){
            return "Hello, allow" # s_name # "!";
        }else{
            return "Hello, " # s_name # "!";
        }
    };

    // 业务处理流程
    public shared(msg) func process() {
        // 业务过程
        let num = 0;
        // 处理结束后上报处理结果
        let allow = await controller_actor.update([{user=msg.caller; data = num;}]);

    };
}
