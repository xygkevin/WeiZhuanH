/**
 * 指尖造梦，精益求精
 * @ProjectName : WeiZhuanH
 * @FileName : PermissionUtil
 * @Author : KEVIN XU
 * @Time : 2026/5/29 18:51
 * @Description : 描述
 */
import { abilityAccessCtrl, bundleManager, Permissions } from "@kit.AbilityKit"

export class PermissionUtil {
  private static atManager = abilityAccessCtrl.createAtManager()

  /**
   * 获取权限状态
   */
  static async getGrantStatus(permissionName: Permissions): Promise<abilityAccessCtrl.GrantStatus> {
    try {
      let bundleInfo = bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
      let appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo
      let tokenId: number = appInfo.accessTokenId
      let grantStatus = await PermissionUtil.atManager.checkAccessToken(tokenId, permissionName)
      return grantStatus
    } catch (err) {
      throw new Error(err)
    }
  }

  /**
   * 向用户申请授权
   */
  static async requestPermissionsFromUser(context: Context, permissions: Array<Permissions>): Promise<boolean> {
    try {
      let result = await PermissionUtil.atManager.requestPermissionsFromUser(context, permissions)
      let grantStatus: Array<number> = result.authResults
      let tempPermissionList: Permissions[] = []
      for (let i = 0; i < grantStatus.length; i++) {
        if (grantStatus[i] != 0) {
          tempPermissionList.push(permissions[i])
        }
      }
      if (tempPermissionList.length == 0) {
        return true
      } else {
        return false
      }
    } catch (err) {
      return false
    }
  }

  /**
   * 二次授权申请
   */
  static async requestPermissionOnSetting(context: Context, permissions: Array<Permissions>): Promise<boolean> {
    try {
      let status = await PermissionUtil.atManager.requestPermissionOnSetting(context, permissions)
      let isSuccess = true
      status.forEach((state) => {
        if (state === abilityAccessCtrl.GrantStatus.PERMISSION_DENIED) {
          isSuccess = false
        }
      })
      return isSuccess
    } catch (err) {
      return false
    }
  }
}