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
import TPush, { TPushEvent } from 'react-native-tpns';

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
    TPush.onRegister((data) => {
      console.log('onRegister', JSON.stringify(data));
    });
    TPush.onNoticeReceived((data) => {
      console.log('onNoticeReceived', JSON.stringify(data));
    });
    TPush.onNoticeClicked((data) => {
      console.log('onNoticeClicked', JSON.stringify(data));
    });
    TPush.onMessageReceived((data) => {
      console.log('onMessageReceived', JSON.stringify(data));
    });
    //????????????????????????iOS???
    TPush.addListener(TPushEvent.SET_BADGE, (data) => {
      console.log('setBadge', JSON.stringify(data));
    });
    TPush.addListener(TPushEvent.UPSERT_ACCOUNTS, (data) => {
      console.log('upsertAccounts', JSON.stringify(data));
    });
    TPush.addListener(TPushEvent.DEL_ACCOUNTS, (data) => {
      console.log('delAccounts', JSON.stringify(data));
    });
    TPush.addListener(TPushEvent.CLEAR_ACCOUNTS, (data) => {
      console.log('clearAccounts', JSON.stringify(data));
    });
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
    return () => {
      TPush.removeAllListeners();
    };
  }, []);

  return (
    <ScrollView style={styles.container}>
      <Button
        title="??????token"
        onPress={() =>
          TPush.getToken().then((token) => Alert.alert('XgPush Token', token))
        }
      />
      <Button
        title="????????????"
        onPress={() => TPush.upsertAccounts([{ type: 0, name: 'TPNS_RN' }])}
      />
      <Button title="????????????" onPress={() => TPush.delAccounts([0])} />
      <Button title="????????????" onPress={() => TPush.clearAccounts()} />
      <Button title="????????????" onPress={() => TPush.addTags(['TPNS_RN'])} />
      <Button title="????????????" onPress={() => TPush.setTags(['TPNS_RN_2'])} />
      <Button title="????????????" onPress={() => TPush.delTags(['TPNS_RN'])} />
      <Button title="????????????" onPress={() => TPush.clearTags()} />
      <Button title="??????????????????" onPress={() => TPush.unregister()} />
      <Button
        title="???????????????Android???"
        onPress={() => TPush.setHeartbeat(50000)}
      />
    </ScrollView>
  );
}
