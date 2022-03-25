import Iter "mo:base/Iter";
import HashMap "mo:base/HashMap";
import Debug "mo:base/Debug";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Server "server";

actor {
    public type PrincipalText = Text;
    
    public type SeviceInfo = {
		server: Principal;
		controller: Principal;
		name: Text;
	};

    let server_map: HashMap.HashMap<Principal, SeviceInfo> = HashMap.HashMap<Principal, SeviceInfo>(10, func (x, y) { x == y }, Principal.hash);

    // 注册到中心服务
    public shared(msg) func register_center(_controller: Principal, _name: Text): async Principal{ 
        _controller
    };

    // 创建业务服务器，创建的时候需要做鉴权处理，
    public shared(msg) func create_server(_controller: Principal, _name: Text): async Principal{ 
        let server = await Server.Server(_controller, _name);
        let sid = Principal.fromActor(server);
        server_map.put(sid, {server = sid; controller = _controller; name = _name;});
        sid
    };

    // 查询业务服务器列表,公开接口 都可以查询
    public query(msg) func server_list(): async [SeviceInfo]{
        Iter.toArray(server_map.vals())
    };

};
