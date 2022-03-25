import Iter "mo:base/Iter";
import Array "mo:base/Array";
import Hash "mo:base/Hash";
import HashMap "mo:base/HashMap";
import Option "mo:base/Option";
import Result "mo:base/Result";
import Debug "mo:base/Debug";
import Principal "mo:base/Principal";

actor {

    public type UserData = Int;

    public type ServiceData = {
        user: Principal;
        data: UserData;
		};
	
    private stable var s_center : ?Principal = null;
    private stable var s_server : ?Principal = null;

    public type CenterActor = actor {
        get_user: (_user: Principal) -> async ?Text;
    };

	let user_map: HashMap.HashMap<Principal, Nat> = HashMap.HashMap<Principal, Nat>(10, func (x, y) { x == y }, Principal.hash);

	public shared(msg) func bind(_server: Principal):async(){
		s_server := ?_server;
		s_center := ?msg.caller;
	};

		// 用户也需要提前注册到这里
    public shared(msg) func register(): async ?Principal{
		// 需要查询中心服务，用户是否存在
		switch(s_center){
			case null { null };
			case (?principal) { 
        let center : CenterActor = actor(Principal.toText(principal));
				let user = await center.get_user(msg.caller);
				switch(user){
					case null { null };
					case (?u) { 
						let principal = msg.caller;
						user_map.put(principal, 10000);
						?principal
					};
				};
			};
		};
    };

	// 用户进入业务时，需要鉴权判断，如果允许返回ture，让用户继续业务
	public shared(msg) func allow(user: Principal) : async Bool{
		switch(s_server){
			case null { false };
			case (?principal) { 
				if(msg.caller == principal){
					switch(user_map.get(user)){
						case null { false };
						case (?n) { 
							if(n > 100){
								true 
							}else{
								false
							}
						}
					}
				}else{
					false
				}
			}
		}
	};

	// 业务结束后， 处理业务数据
	public shared(msg) func update(result: [ServiceData]) : async (){
		switch(s_server){
			case null {  };
			case (?principal) { 
			};
		}
	};

 
};
