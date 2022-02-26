import Iter "mo:base/Iter";
import Array "mo:base/Array";
import HashMap "mo:base/HashMap";
import Debug "mo:base/Debug";
import Principal "mo:base/Principal";
import Text "mo:base/Text";

actor {
    
    public type PrincipalText = Text;
    public type UserInfo = Text;

    public type ManagerInfo = {
        principal: Principal;
        name: Text;
    };

    public type ServerInfo = {
		server: Principal;
		controller: Principal;
		name: Text;
	};

    public type ManagerActor = actor {
        create_server: (_principal: Principal, _name: Text) -> async Principal;
        server_list: () -> async ?[ServerInfo];
    };

    public type ControllerActor = actor {
        bind: (_server: Principal) -> async ();
    };

    let manager_map: HashMap.HashMap<Principal, ManagerInfo> = HashMap.HashMap<Principal, ManagerInfo>(10, func (x, y) { x == y }, Principal.hash);
    let user_map: HashMap.HashMap<Principal, UserInfo> = HashMap.HashMap<Principal, UserInfo>(10, func (x, y) { x == y }, Principal.hash);
    
    // 游戏申请上线接口
    public shared(msg) func register_manager(_principal: PrincipalText, _name: Text): async Principal{
        let mng_principal = Principal.fromText(_principal);
        manager_map.put(mng_principal, {principal = mng_principal; name = _name;});
        mng_principal
    };

    // 控制器创建游戏房间, 一个控制器只能创建一个游戏
    public shared(msg) func create_server(_controller: PrincipalText, _manager: PrincipalText, _name :Text): async ?Principal{
        let mng_principal = Principal.fromText(_manager);
        
        // 增加对对游戏创建的权限判断，增加是否是注册游戏的判断
        switch(manager_map.get(mng_principal)){
            case null { null };
            case (?m) { 
                let manager : ManagerActor = actor(_manager);
                let server = await manager.create_server(Principal.fromText(_controller), _name);
                
                let controller : ControllerActor = actor(_controller);
                await controller.bind(server);
                ?server
            };
        };
    };


    public query func manager_list(): async [ManagerInfo]{
        return Iter.toArray(manager_map.vals());
    };


    public func sever_list(_principal: PrincipalText): async ?[ServerInfo]{
        // 增加对对游戏创建的权限判断，增加是否是注册游戏的判断
        let mng_principal = Principal.fromText(_principal);
        switch(manager_map.get(mng_principal)){
            case null { null };
            case (?m) { 
                let manager : ManagerActor = actor(_principal);
                return await manager.server_list();
            };
        };
    };


    // 用户相关接口

    // 用户注册
    public shared(msg) func register(_name: Text): async Principal{
        let principal = msg.caller;
        user_map.put(principal, _name);
        principal
    };
 
    // 用户登录
    public shared(msg) func login(): async ?UserInfo{
        user_map.get(msg.caller)
    };

    // 查询用户信息
    public shared(msg) func get_user(_user: Principal): async ?UserInfo{
        user_map.get(_user)
    };
};