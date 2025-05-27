class AppUrl {
  static final baseHost = "teksmartsolutions.com/MOFAAPI_DEV/api";
  static final baseHttp = "https://";
  static final baseUrl = "$baseHttp$baseHost";

  //Auth
  static final pathLogin = "/ExternalLogin/Login"; //POST
  static final pathToken = "/ExternalLogin/Token"; //POST
  static final pathCountryList = "/Nationalities/GetAll"; //POST
  static final pathRegister = "/ExternalRegistration/Add"; //POST
  static final pathForgetPassword = "/ExternalUser/ForgetPassword"; //POST
  static final pathUpdateProfile = "/ExternalUser/UpdateProfile"; //POST
  static final pathGetProfile = "/ExternalUser/GetProfile"; //POST

  //Apply Pass
  static final pathLocationDropdown = "/Locations/GetAllDropdown"; //POST
  static final pathVisitRequestTypeDropdown = "/VisitRequestTypes/GetAll"; //POST
  static final pathDeviceDropdown = "/SystemCodes/GetAllDetailCodesDropDown"; //POST
  static final pathVisitPurposesDropdown = "/VisitPurposes/GetAllDropdown"; //POST
  // static final pathGetById = "/ExternalUser/GetById"; //POST
  static final pathGetById = "/ExternalUser/GetLatestAppointmentData"; //POST
  static final pathGetByIdAppointment = "/ExternalAppointment/GetById"; //POST
  static final pathGetFile = "/Appointment/GetFile"; //POST
  static final pathExternalGetFile = "/ExternalAppointment/GetFile"; //POST
  static final pathValidateEmail = "/Validation/ValidateEmail"; //POST
  static final pathDuplicateAppointment = "/Validation/DuplicateAppointment"; //POST
  static final pathAddAppointment = "/ExternalAppointment/Add"; //POST
  static final pathAddAttachment = "/ExternalAppointment/AddAttachments"; //POST

  //Search Pass
  static final pathGetAllDetail = "/ExternalAppointment/GetAll"; //POST
  static final pathApprovalTypesDropdown = "/ApprovalTypes/GetAll"; //POST
  static final pathCancelAppointment = "/ExternalAppointment/Cancel"; //POST
  static final pathSearchComments = "/Appointment/SearchComments"; //POST
  static final pathUpdateAppointment = "/ExternalAppointment/Update"; //POST

}
