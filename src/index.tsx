import { NativeModules } from 'react-native';

type TpnsType = {
  multiply(a: number, b: number): Promise<number>;
};

const { Tpns } = NativeModules;

export default Tpns as TpnsType;
