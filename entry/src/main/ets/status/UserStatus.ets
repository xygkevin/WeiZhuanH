/**
 * 指尖造梦，精益求精
 * @ProjectName : WeiZhuanH
 * @FileName : UserStatus
 * @Author : KEVIN XU
 * @Time : 2026/6/10 17:10
 * @Description : 描述
 */
import { TokenModel } from "../model/TokenModel";
import { UserModel } from "../model/UserModel";
import { PersistenceV2, Type } from "@ohos.arkui.StateManagement";

@ObservedV2
export class UserStatus {
  /**
   * 用户
   */
  @Type(UserModel)
  @Trace user: UserModel = new UserModel()
  /**
   * Token
   */
  @Type(TokenModel)
  @Trace token: TokenModel = new TokenModel()

  /**
   * 更新Token
   */
  public updateToken(token?: TokenModel) {
    if (token) {
      this.token = token
      this.save()
    } else {
      this.logout()
    }
  }

  /**
   * 是否已登录
   */
  public isLoggedIn(): boolean {
    return this.token.isValid()
  }

  /**
   * 更新用户
   */
  public updateUser(user?: UserModel) {
    this.user = user ?? new UserModel()
    this.save()
  }

  /**
   * 登录
   */
  public login(token: TokenModel) {
    this.token = token
    this.save()
  }

  /**
   * 退出登录
   */
  public logout() {
    this.token = new TokenModel()
    this.user = new UserModel()
    this.save()
  }

  /**
   * 同步
   */
  private save() {
    PersistenceV2.save(UserStatus)
  }
}

/**
 *
 */
export const kUserStatus = PersistenceV2.connect<UserStatus>(UserStatus, () => new UserStatus())!