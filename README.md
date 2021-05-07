# react-native-tpns

react-native tpns plugin

## Installation

```sh
npm install react-native-tpns
```

## Usage

```js
import TPush, { TPushEvent } from "react-native-tpns";

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
TPush.onRegister((data) => {
  console.log('onRegister', JSON.stringify(data));
});
// 收到通知消息
TPush.onNoticeReceived((data) => {
  console.log('onNoticeReceived', JSON.stringify(data));
});
// 通知消息被点击
TPush.onNoticeClicked((data) => {
  console.log('onNoticeClicked', JSON.stringify(data));
});
// 收到透传或静默消息
TPush.onMessageReceived((data) => {
  console.log('onMessageReceived', JSON.stringify(data));
});
//设置角标回调（仅iOS）
TPush.addListener(TPushEvent.SET_BADGE, (data) => {
  console.log('setBadge', JSON.stringify(data));
});
// Account 相关事件
TPush.addListener(TPushEvent.UPSERT_ACCOUNTS, (data) => {
  console.log('upsertAccounts', JSON.stringify(data));
});
TPush.addListener(TPushEvent.DEL_ACCOUNTS, (data) => {
  console.log('delAccounts', JSON.stringify(data));
});
TPush.addListener(TPushEvent.CLEAR_ACCOUNTS, (data) => {
  console.log('clearAccounts', JSON.stringify(data));
});
// Tag 相关事件
TPush.addListener(TPushEvent.ADD_TAGS, (data) => {
  console.log('addTags', JSON.stringify(data));
});
TPush.addListener(TPushEvent.SET_TAGS, (data) => {
  console.log('setTags', JSON.stringify(data));
});
TPush.addListener(TPushEvent.DEL_TAGS, (data) => {
  console.log('delTags', JSON.stringify(data));
});
TPush.addListener(TPushEvent.CLEAR_TAGS, (data) => {
  console.log('clearTags', JSON.stringify(data));
});
```

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
