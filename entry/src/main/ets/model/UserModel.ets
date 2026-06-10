/**
 * 指尖造梦，精益求精
 * @ProjectName : WeiZhuanH
 * @FileName : UserModel
 * @Author : KEVIN XU
 * @Time : 2026/6/10 17:10
 * @Description : 描述
 */

@ObservedV2
export class UserModel {
  @Trace id: number = 0
  @Trace nickname: string = ''
  @Trace age: number = 18
  @Trace gender: number = 0
  @Trace mobile: string = '--'
  @Trace email: string = '--'
  @Trace memberCode: string = '--'

  isValid(): boolean {
    return this.id !== 0
  }
}