import Iter "mo:base/Iter";
import HashMap "mo:base/HashMap";
import Debug "mo:base/Debug";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Server "server";

actor {
    public type PrincipalText = Text;
    
    public type ServerInfo = {
		server: Principal;
		controller: Principal;
		name: Text;
	};

    let server_map: HashMap.HashMap<Principal, ServerInfo> = HashMap.HashMap<Principal, ServerInfo>(10, func (x, y) { x == y }, Principal.hash);

    // 平台创建游戏房间接口
    public shared(msg) func create_server(_principal: Principal, _name: Text): async Principal{ 
        let server = await Server.Game(_principal, _name);
        let sid = Principal.fromActor(server);
        server_map.put(sid, {server = sid; controller = _principal; name = _name;});
        sid
    };

    public query func server_list(): async ?[ServerInfo]{
        ?Iter.toArray(server_map.vals())
    };

    // 游戏开始接口


    // 游戏结束
 
};
