/**
 * 指尖造梦，精益求精
 * @ProjectName : WeiZhuanH
 * @FileName : NetworkUtil
 * @Author : KEVIN XU
 * @Time : 2026/6/16 14:16
 * @Description : 描述
 */
import { connection, statistics } from "@kit.NetworkKit";
import { hilog } from "@kit.PerformanceAnalysisKit";
import { bundleManager } from "@kit.AbilityKit";

export const NETWORK_CONNECTION_TIMEOUT: number = 1000

@ObservedV2
export class NetworkUtil {
  @Trace readonly isReachable: boolean = true
  private static instance: NetworkUtil = new NetworkUtil()

  static shared(): NetworkUtil {
    return NetworkUtil.instance
  }

  private netConnection: connection.NetConnection

  private constructor() {
    let netSpecifier: connection.NetSpecifier = {
      netCapabilities: {
        // 可指定网络类型为 CELLULAR 和 WIFI
        bearerTypes: [connection.NetBearType.BEARER_CELLULAR, connection.NetBearType.BEARER_WIFI],
        // 指定网络能力为 Internet
        networkCap: [connection.NetCap.NET_CAPABILITY_INTERNET]
      }
    }
    // 指定超时时间为10s(默认值为0)
    let TIMEOUT: number = 10 * NETWORK_CONNECTION_TIMEOUT;
    this.netConnection = connection.createNetConnection(netSpecifier, TIMEOUT)
    // 订阅事件，如果当前指定网络可用，通过on_netAvailable通知用户
    this.netConnection.on('netAvailable', (data: connection.NetHandle) => {
      hilog.info(0x0000, 'testTag', '网络可用' + data.netId);
    });
    // 订阅事件，如果当前指定网络不可用，通过on_netUnavailable通知用户
    this.netConnection.on('netUnavailable', (data: void) => {
      hilog.info(0x0000, 'testTag', '网络不可用' + JSON.stringify(data));
    });
    // 订阅网络能力变化事件，如果当前指定网络的能力发生变化，通过on_netCapabilitiesChange通知用户
    this.netConnection.on('netCapabilitiesChange', (data: connection.NetCapabilityInfo) => {
      hilog.info(0x0000, 'testTag', '网络能力变化' + JSON.stringify(data));
    });
    // 订阅网络连接信息变化事件，如果当前指定网络的连接信息发生变化，通过on_netConnectionPropertiesChange通知用户
    this.netConnection.on('netConnectionPropertiesChange', (data: connection.NetConnectionPropertyInfo) => {
      hilog.info(0x0000, 'testTag', '网络连接变化' + JSON.stringify(data));
    });
    // 订阅网络丢失事件，如果当前处于连接状态的指定网络断开，通过on_netLost通知用户
    this.netConnection.on('netLost', (data: connection.NetHandle) => {
      hilog.info(0x0000, 'testTag', '网络丢失' + JSON.stringify(data));
    });
  }


  register() {
    // 订阅连接状态变化
    this.netConnection.register((error: BusinessError) => {
      if (error) {
        hilog.error(0x0000, 'NetworkUtil', '注册网络监听失败' + JSON.stringify(error));
      } else {
        hilog.info(0x0000, 'NetworkUtil', '注册网络监听成功');
      }
    })
  }

  unregister() {
    this.netConnection.unregister((error: BusinessError, data: void) => {
      if (error) {
        hilog.error(0x0000, 'NetworkUtil', '取消注册网络监听失败' + JSON.stringify(error));
      } else {
        hilog.info(0x0000, 'NetworkUtil', '取消注册网络监听成功');
      }
    })
  }

  static async getAllNets() {
    try {
      let result: connection.NetHandle[] = await connection.getAllNets()
      result.forEach((data: connection.NetHandle) => {

      })
      return result
    } catch (error) {
      throw new Error(error)
    }
  }

  /**
   * 判断默认网络是否可以访问互联网
   */
  static async currentNetworkIsAvailable(): Promise<boolean> {
    try {
      // 获取默认激活的数据网络。
      let netHandle = await connection.getDefaultNet();
      if (!netHandle || netHandle.netId === 0) {
        return false
      }
      // 获取netHandle对应网络的能力信息。
      let netCapabilities = await connection.getNetCapabilities(netHandle);
      let cap = netCapabilities.networkCap;
      // 判断网络是否可以访问互联网。
      if (cap?.includes(connection.NetCap.NET_CAPABILITY_CHECKING_CONNECTIVITY)) {
        // 正在验证网络连通性，请稍后重试。
        hilog.info(0x0000, 'testTag', 'default network is checking, please try again later');
        return false
      } else {
        if (cap?.includes(connection.NetCap.NET_CAPABILITY_VALIDATED)) {
          // 网络连通性验证成功，当前默认网络可以访问互联网。
          hilog.info(0x0000, 'testTag', 'default network is validated');
          return true
        } else {
          // 网络连通性验证失败，当前默认网络不可以访问互联网。
          hilog.info(0x0000, 'testTag', 'default network is not validated');
          return false
        }
      }
    } catch (error) {
      return false
    }
  }

  static async fetchBytes() {
    try {
      // wlan0为主WiFi网卡名，获取主WiFi实时下行流量数据。
      let wifi_down = await statistics.getIfaceRxBytes('wlan0')
      // wlan0为主WiFi网卡名，获取主WiFi实时上行流量数据。
      let wifi_up = await statistics.getIfaceTxBytes('wlan0')

      // 获取蜂窝实时下行流量数据。
      let cell_down = await statistics.getCellularRxBytes()
      // 获取蜂窝实时上行流量数据。
      let cell_up = await statistics.getCellularTxBytes()

      // 获取所有网卡实时下行流量数据。
      let all_down = await statistics.getAllRxBytes()
      // 获取所有网卡实时上行流量数据。
      let all_up = await statistics.getAllTxBytes()

      // 获取指定应用实时下行流量数据。
      let bundleInfo =
        await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
      let uid = bundleInfo.appInfo.uid
      // 获取指定应用实时下行流量数据。
      let uid_down = await statistics.getUidRxBytes(uid)
      // 获取指定应用实时上行流量数据。
      let uid_up = await statistics.getUidTxBytes(uid)

    } catch (error) {
      throw new Error(error)
    }
  }
}