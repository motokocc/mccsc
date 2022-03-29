# mccsc

#### Description
motoko多canister框架
由center，service，controller组成，三个容器都可以单独部署
center管理用户，存储用户数据，所有的业务都从这个服务创建，然后交给controller管理
service主要处理业务，只关注业务逻辑的实现，不需要考虑存储
controller 管理业务，存储业务相关数据，

#### Software Architecture
中心：存储核心数据：用户信息 、管理器信息，// 部署频率低、尽量做到一次部署永久使用，如果只存储用户数据
控制器：存储用户业务数据，一个业务服务可以对应多个控制器，
业务服务有两部分组成： 管理器和服务
管理器：负责创建业务canister和维护业务canister信息，控制器和具体的业务服务之间的关联关系
服务：具体的业务逻辑服务，可以有多个canister实例

