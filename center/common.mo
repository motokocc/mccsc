
import Principal "mo:base/Principal";

module {
    public type Service = {  
		name: Text;
		principal: Principal;
	};

    public type ServiceManagerActor = actor {
        create_service: (_owner: Principal, _name: Text) -> async Principal;
        //room_list: () -> (vec RoomInfo) query;
    };

    
    public type DataActor = actor {
        create_service: (_principal: Text, _name :Text) -> async Principal;
        //room_list: () -> (vec RoomInfo) query;
    };
}