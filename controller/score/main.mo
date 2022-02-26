import Iter "mo:base/Iter";
import Array "mo:base/Array";
import Hash "mo:base/Hash";
import HashMap "mo:base/HashMap";
import Option "mo:base/Option";
import Result "mo:base/Result";
import Debug "mo:base/Debug";
import Principal "mo:base/Principal";

actor {

	public type ServerResult = {
		user: Principal;
		score: Int;
	};
	
    private stable var sCenter : ?Principal = null;
    private stable var sServer : ?Principal = null;

    public type CenterActor = actor {
        get_user: (_user: Principal) -> async ?Text;
    };

	let user_map: HashMap.HashMap<Principal, Nat> = HashMap.HashMap<Principal, Nat>(10, func (x, y) { x == y }, Principal.hash);

	public shared(msg) func bind(_server: Principal):async(){
		sServer := ?_server;
		sCenter := ?msg.caller;
	};

	// 用户也需要提前注册到这里
    public shared(msg) func register(): async ?Principal{
		// 需要查询中心服务，用户是否存在
		switch(sCenter){
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

	// 玩家进入游戏判断-游戏回调
	public shared(msg) func allow(user: Principal) : async Bool{
		switch(sServer){
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

	// 游戏结算-游戏回调
	//public shared(msg) func over(result: [GameResult]) : async [GameResult]{
	public shared(msg) func over(result: [ServerResult]) : async (){
		switch(sServer){
			case null {  };
			case (?principal) { 
			};
		}
	};


	// 玩家获取积分接口

	// 自定义扩展，充值/提现等接口
 
};
