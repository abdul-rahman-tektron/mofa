class AppUrl {
  static final baseHost = "teksmartsolutions.com/MOFAAPI_DEV/api";
  static final baseHttp = "https://";
  static final baseUrl = "$baseHttp$baseHost";

  //login
  static final pathLogin = "/ExternalLogin/Login"; //POST
  static final pathCountryList = "/Nationalities/GetAll"; //POST
  static final pathRegister = "/ExternalRegistration/Add"; //POST
  static final pathForgetPassword = "/ExternalUser/ForgetPassword"; //POST
  static final pathLocationDropdown = "/Locations/GetAllDropdown"; //POST
  static final pathVisitRequestTypeDropdown = "/VisitRequestTypes/GetAll"; //POST
  static final pathDeviceDropdown = "/SystemCodes/GetAllDetailCodesDropDown"; //POST
  static final pathVisitPurposesDropdown = "/VisitPurposes/GetAllDropdown"; //POST
  static final pathGetById = "/ExternalUser/GetById"; //POST
  static final pathGetFile = "/Appointment/GetFile"; //POST
}
