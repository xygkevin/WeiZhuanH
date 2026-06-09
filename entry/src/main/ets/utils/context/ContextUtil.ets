/**
 * 指尖造梦，精益求精
 * @ProjectName : WeiZhuanH
 * @FileName : ContextUtil
 * @Author : KEVIN XU
 * @Time : 2026/5/29 18:50
 * @Description : 描述
 */
import common from "@ohos.app.ability.common"
import { UIContext } from "@kit.ArkUI"

export class ContextUtil {
  private static wzAbilityContext?: common.UIAbilityContext
  private static wzUIContext?: UIContext

  public static init(context: common.UIAbilityContext) {
    ContextUtil.wzAbilityContext = context
  }

  public static setUIContext(uiContext: UIContext) {
    ContextUtil.wzUIContext = uiContext
  }

  public static removeUIContext() {
    ContextUtil.wzUIContext = undefined
  }

  public static uiContext(): UIContext {
    return ContextUtil.wzUIContext ?? UIContext.resolveUIContext()
  }

  public static abilityContext(): common.UIAbilityContext | undefined {
    return ContextUtil.wzAbilityContext
  }

  public static applicationContext(): common.ApplicationContext | undefined {
    return ContextUtil.wzAbilityContext?.getApplicationContext()
  }
}