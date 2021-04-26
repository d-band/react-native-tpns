# react-native-tpns

react-native tpns plugin

## Installation

```sh
npm install react-native-tpns
```

## Usage

```js
import TPush, { AccountEvent, TagEvent } from "react-native-tpns";

// ...
// 设置 Debug 模式
TPush.enableDebug(true);
// 注册推送服务（iOS 需传 appId 和 appKey）
TPush.register(appId, appKey, 'tpns.sh.tencent.com');
// 注销推送服务
TPush.unregister();
// 获取 Token（返回 Promise<string>）
TPush.getToken();
/** Account 相关操作 **/
TPush.upsertAccounts([{ name: 'account_name', type: 0 }]);
TPush.delAccounts([0]);
TPush.clearAccounts();
/** Tag 相关操作 **/
TPush.addTags(['TPNS_RN']);
TPush.setTags(['TPNS_RN_2']);
TPush.delTags(['TPNS_RN']);
TPush.clearTags();
/** 事件 **/
TPush.addOnRegisteredDeviceTokenListener((data) => {});
TPush.addOnRegisteredDoneListener((data) => {});
TPush.addUnRegisteredListener((data) => {});
TPush.addOnReceiveNotificationResponseListener((data) => {});
TPush.addOnReceiveMessageListener((data) => {});
TPush.addClickActionListener((data) => {});
// 设置角标回调（仅iOS）
TPush.addDidSetBadgeListener((data) => {});
// Account 相关回调
TPush.addAccountListener(AccountEvent.UPSERT, (data) => {});
TPush.addAccountListener(AccountEvent.DEL, (data) => {});
TPush.addAccountListener(AccountEvent.CLEAR, (data) => {});
// Tag 相关回调
TPush.addTagListener(TagEvent.ADD, (data) => {});
TPush.addTagListener(TagEvent.SET, (data) => {});
TPush.addTagListener(TagEvent.DEL, (data) => {});
TPush.addTagListener(TagEvent.CLEAR, (data) => {});
```

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
