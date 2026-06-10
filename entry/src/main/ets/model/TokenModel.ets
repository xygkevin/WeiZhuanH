/**
 * 指尖造梦，精益求精
 * @ProjectName : WeiZhuanH
 * @FileName : TokenModel
 * @Author : KEVIN XU
 * @Time : 2026/6/10 17:12
 * @Description : 描述
 */

@ObservedV2
export class TokenModel {
  @Trace token: string = ''
  @Trace refreshToken: string = ''
  @Trace expired: number = 0

  isValid(): boolean {
    return this.token.length > 0 && this.refreshToken.length > 0 && this.expired > Date.now()
  }
}