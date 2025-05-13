class AppUrl {
  static final baseHost = "teksmartsolutions.com/MOFAAPI_DEV/api";
  static final baseHttp = "https://";
  static final baseUrl = "$baseHttp$baseHost";

  //login
  static final pathLogin = "/ExternalLogin/Login"; //POST
  static final pathCountryList = "/Nationalities/GetAll"; //POST
  static final pathRegister = "/ExternalRegistration/Add"; //POST
}
