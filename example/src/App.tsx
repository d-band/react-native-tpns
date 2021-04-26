import React, { useEffect } from 'react';
import {
  StyleSheet,
  Text,
  ScrollView,
  TouchableOpacity,
  GestureResponderEvent,
  Platform,
  Alert,
} from 'react-native';
import TPush, { AccountEvent, TagEvent } from 'react-native-tpns';

const styles = StyleSheet.create({
  container: {
    flex: 1,
    marginTop: 22,
    marginBottom: 17,
    paddingHorizontal: 10,
    backgroundColor: '#F5FCFF',
  },
  btn: {
    justifyContent: 'center',
    alignItems: 'center',
    marginTop: 10,
    borderRadius: 3,
    backgroundColor: '#3e83d7',
    padding: 10,
  },
  text: {
    textAlign: 'center',
    fontSize: 18,
    color: '#ffffff',
  },
});

function Button(props: {
  title: string;
  onPress: (event: GestureResponderEvent) => void;
}) {
  return (
    <TouchableOpacity style={styles.btn} onPress={props.onPress}>
      <Text style={styles.text}>{props.title}</Text>
    </TouchableOpacity>
  );
}

export default function App() {
  const openOtherChannel = () => {
    if (Platform.OS === 'ios') return;
    const miAppId = process.env.XG_PUSH_MI_APP_ID;
    const miAppKey = process.env.XG_PUSH_MI_APP_KEY;
    if (miAppId && miAppKey) {
      TPush.setMiPush(miAppId, miAppKey);
    }
    const mzAppId = process.env.XG_PUSH_MZ_APP_ID;
    const mzAppKey = process.env.XG_PUSH_MZ_APP_KEY;
    if (mzAppId && mzAppKey) {
      TPush.setMzPush(mzAppId, mzAppKey);
    }
    const oppoAppId = process.env.XG_PUSH_OPOO_APP_ID;
    const oppoAppKey = process.env.XG_PUSH_OPOO_APP_KEY;
    if (oppoAppId && oppoAppKey) {
      TPush.setOppoPush(oppoAppId, oppoAppKey);
      TPush.enableOppoNotification(true);
    }
    TPush.enableOtherPush(true);
  };

  useEffect(() => {
    TPush.enableDebug(true);
    openOtherChannel();
    const appId = process.env.XG_PUSH_APP_ID;
    const appKey = process.env.XG_PUSH_APP_KEY;
    TPush.register(appId, appKey, 'tpns.sh.tencent.com');
    TPush.addOnRegisteredDeviceTokenListener((data) => {
      console.log('addOnRegisteredDeviceTokenListener', JSON.stringify(data));
    });
    TPush.addOnRegisteredDoneListener((data) => {
      console.log('addOnRegisteredDoneListener', JSON.stringify(data));
    });
    TPush.addUnRegisteredListener((data) => {
      console.log('addUnRegisteredListener', JSON.stringify(data));
    });
    TPush.addOnReceiveNotificationResponseListener((data) => {
      console.log(
        'addOnReceiveNotificationResponseListener',
        JSON.stringify(data)
      );
    });
    TPush.addOnReceiveMessageListener((data) => {
      console.log('addOnReceiveMessageListener', JSON.stringify(data));
    });
    TPush.addClickActionListener((data) => {
      console.log('addClickActionListener', JSON.stringify(data));
    });
    //设置角标回调（仅iOS）
    TPush.addDidSetBadgeListener((data) => {
      console.log('addDidSetBadgeListener', JSON.stringify(data));
    });
    TPush.addAccountListener(AccountEvent.UPSERT, (data) => {
      console.log('addAccountListener(upsert)', JSON.stringify(data));
    });
    TPush.addAccountListener(AccountEvent.DEL, (data) => {
      console.log('addAccountListener(del)', JSON.stringify(data));
    });
    TPush.addAccountListener(AccountEvent.CLEAR, (data) => {
      console.log('addAccountListener(clear)', JSON.stringify(data));
    });
    TPush.addTagListener(TagEvent.ADD, (data) => {
      console.log('addTagListener(add)', JSON.stringify(data));
    });
    TPush.addTagListener(TagEvent.SET, (data) => {
      console.log('addTagListener(set)', JSON.stringify(data));
    });
    TPush.addTagListener(TagEvent.DEL, (data) => {
      console.log('addTagListener(del)', JSON.stringify(data));
    });
    TPush.addTagListener(TagEvent.CLEAR, (data) => {
      console.log('addTagListener(clear)', JSON.stringify(data));
    });
    return () => {
      TPush.removeAllListeners();
    };
  }, []);

  return (
    <ScrollView style={styles.container}>
      <Button
        title="获取token"
        onPress={() =>
          TPush.getToken().then((token) => Alert.alert('XgPush Token', token))
        }
      />
      <Button
        title="添加账号"
        onPress={() => TPush.upsertAccounts([{ type: 0, name: 'TPNS_RN' }])}
      />
      <Button title="删除账号" onPress={() => TPush.delAccounts([0])} />
      <Button title="清空账号" onPress={() => TPush.clearAccounts()} />
      <Button title="追加标签" onPress={() => TPush.addTags(['TPNS_RN'])} />
      <Button title="覆盖标签" onPress={() => TPush.setTags(['TPNS_RN_2'])} />
      <Button title="删除标签" onPress={() => TPush.delTags(['TPNS_RN'])} />
      <Button title="清空标签" onPress={() => TPush.clearTags()} />
      <Button title="注消推送服务" onPress={() => TPush.unregister()} />
      <Button
        title="设置心跳（Android）"
        onPress={() => TPush.setHeartbeat(50000)}
      />
    </ScrollView>
  );
}
