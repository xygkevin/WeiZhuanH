/**
 * 指尖造梦，精益求精
 * @ProjectName : WeiZhuanH
 * @FileName : AppUtil
 * @Author : KEVIN XU
 * @Time : 2026/5/29 18:49
 * @Description : 描述
 */
import { bundleManager } from "@kit.AbilityKit";

export class AppUtil {
  private static wzBundleInfo?: bundleManager.BundleInfo

  public static bundleInfo(): bundleManager.BundleInfo {
    if (!AppUtil.wzBundleInfo) {
      AppUtil.wzBundleInfo = bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT)
    }
    return AppUtil.wzBundleInfo
  }

  public static displayName(): string {
    return AppUtil.bundleInfo().appInfo.name
  }

  public static bundleName(): string {
    return AppUtil.bundleInfo().name
  }

  public static versionName(): string {
    return AppUtil.bundleInfo().versionName
  }

  public static versionCode(): number {
    return AppUtil.bundleInfo().versionCode
  }

  public static isDebug(): boolean {
    return AppUtil.bundleInfo().appInfo.debug
  }
}