# These were not auto generated for some reason

module VimSdk
  module VmomiSupport

    create_data_type("vmodl.MethodFault", "MethodFault", "vmodl.DynamicData", "vmodl.version.version0", [["msg", "string", "vmodl.version.version0", {:optional => true}], ["faultCause", "vmodl.MethodFault", "vmodl.version.version1", {:optional => true}], ["faultMessage", "vmodl.LocalizableMessage[]", "vmodl.version.version1", {:optional => true}]])
    create_data_type("vmodl.RuntimeFault", "RuntimeFault", "vmodl.MethodFault", "vmodl.version.version0", [])
    create_data_type("vmodl.LocalizedMethodFault", "LocalizedMethodFault", "vmodl.MethodFault", "vmodl.version.version0", [["fault", "vmodl.MethodFault", "vmodl.version.version0", {}], ["localizedMessage", "string", "vmodl.version.version0", {:optional => true}]])
    if $vc_version == '7.0'
      create_managed_type("sms.auth.SessionManager", "SmsSessionManager", "vmodl.ManagedObject", "sms.version.version5", nil, [["loginByToken", "SmsLoginByToken", "sms.version.version5", [["delegatedTokenXml", "string", "sms.version.version5", {}, nil]], [{}, "void", "void"], "System.Anonymous", ["sms.fault.InvalidLogin"]], ["logout", "SmsLogout", "sms.version.version5", [], [{}, "void", "void"], "StorageViews.View", nil]])
    end
  end
end