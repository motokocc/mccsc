import Iter "mo:base/Iter";
import Array "mo:base/Array";
import HashMap "mo:base/HashMap";
import Debug "mo:base/Debug";
import Principal "mo:base/Principal";
import Text "mo:base/Text";

actor {
    
    public type PrincipalText = Text;
    public type UserInfo = Text;

    // 业务管理容器
    public type ManagerInfo = {
        principal: Principal;
        name: Text;
    };

    // 管理器接口
    public type ManagerActor = actor {
        create_server: (_principal: Principal, _name: Text) -> async Principal;
        server_list: () -> async [SeviceInfo];
    };

    // 控制器接口
    public type ControllerActor = actor {
        bind: (_server: Principal) -> async ();
    };

    // 数据存储，为了方便目前才用了HashMap存储，使用的时候，用支持stable的类型来替换，还要考虑升级的操作
    let manager_map: HashMap.HashMap<Principal, ManagerInfo> = HashMap.HashMap<Principal, ManagerInfo>(10, func (x, y) { x == y }, Principal.hash);
    let user_map: HashMap.HashMap<Principal, UserInfo> = HashMap.HashMap<Principal, UserInfo>(10, func (x, y) { x == y }, Principal.hash);
    
    // 服务管理器注册接口， 所有的服务都由服务管理器来创建
    public shared(msg) func register_manager(_manager: Principal, _name: Text): async Principal{
        manager_map.put(_manager, {principal = _manager; name = _name;});
        _manager
    };


    // 控制器创建业务服务接口, 一个控制器只能创建一个业务，创建后服务和控制器绑定
    public shared(msg) func create_server(_controller: Principal, _manager: Principal, _name :Text): async ?Principal{
        // 增加访问权限判断
        switch(manager_map.get(_manager)){
            case null { null };
            case (?m) { 
                let manager : ManagerActor = actor(Principal.toText(_manager));
                let server = await manager.create_server(_controller, _name);
                
                let controller : ControllerActor = actor(Principal.toText(_controller));
                await controller.bind(server);
                ?server
            };
        };
    };


    // 查询业务管理服务列表，相当于业务服务类型
    public query(msg) func manager_list(): async [ManagerInfo]{
        return Iter.toArray(manager_map.vals());
    };

    // 用户注册
    public shared(msg) func register(_info: UserInfo): async Principal{
        let principal = msg.caller;
        user_map.put(principal, _info);
        principal
    };
 
    // 用户登录
    public query(msg) func login(): async ?UserInfo{
        user_map.get(msg.caller)
    };

    // 查询用户信息
    public query(msg) func get_user(_user: Principal): async ?UserInfo{
        user_map.get(_user)
    };
};
