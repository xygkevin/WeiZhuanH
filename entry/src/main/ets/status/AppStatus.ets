/**
 * 指尖造梦，精益求精
 * @ProjectName : WeiZhuanH
 * @FileName : AppStatus
 * @Author : KEVIN XU
 * @Time : 2026/6/10 17:10
 * @Description : 描述
 */
import { AppStorageV2 } from "@kit.ArkUI"


@ObservedV2
export class AppStatus {
  /**
   * 是否冷已启动
   */
  @Trace isLaunch: boolean = false
  /**
   * 是否热启动
   */
  @Trace hotLaunch: boolean = false
}

/**
 * 全局使用
 */
export const kAppStatus = AppStorageV2.connect<AppStatus>(AppStatus, ()=> new AppStatus())!
