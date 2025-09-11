class AppUrl {
  static final baseHost = "teksmartsolutions.com/MOFAAPI_DEV/api";
  // static final baseHost = "teksmartsolutions.com/MOFAAPI/api";
  static final baseHttp = "https://";
  static final baseUrl = "$baseHttp$baseHost";
  //Auth
  static final pathLogin = "/ExternalLogin/Login"; //POST
  static final pathToken = "/ExternalLogin/Token"; //POST
  static final pathGetCaptcha = "/ExternalLogin/GetVMSCaptchaParams"; //POST
  static final pathCaptchaLogin = "/ExternalLogin/CaptchaLogin"; //POST
  static final pathCountryList = "/Nationalities/GetAll"; //POST
  static final pathRegister = "/ExternalRegistration/Add"; //POST
  static final pathResendOTP = "/ExternalLogin/ResendOTP"; //POST
  static final pathValidateOTP = "/ExternalLogin/ValidateOTP"; //POST
  static final pathForgetPassword = "/ExternalUser/ForgetPassword"; //POST
  static final pathUpdateProfile = "/ExternalUser/UpdateProfile"; //POST
  static final pathGetProfile = "/ExternalUser/GetProfile"; //POST
  static final pathDeleteAccount = "/ExternalUser/Delete"; //POST
  static final pathUpdatePassword = "/ExternalUser/UpdatePassword"; //POST

  //Apply Pass
  static final pathLocationDropdown = "/Locations/GetAllDropdown"; //POST
  static final pathBuildingDropdown = "/Buildings/GetAllDropdown"; //POST
  static final pathVisitRequestTypeDropdown = "/VisitRequestTypes/GetAll"; //POST
  static final pathDeviceDropdown = "/SystemCodes/GetAllDetailCodesDropDown"; //POST
  static final pathVisitPurposesDropdown = "/VisitPurposes/GetAllDropdown"; //POST
  static final pathPlateSourceDropdown = "/PlateSource/GetAll"; //POST
  static final pathPlateLetterDropdown = "/PlateLetters/GetAll"; //POST
  static final pathSearchUser = "/Appointment/SearchUser"; //POST
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

  //Dashboard
  static final pathDashboardKpi = "/ExternalDashboard/Kpi"; //POST
  static final pathVisitingHoursConfig = "/Configs/GetVisitingHoursConfig"; //POST
  static final pathValidatePhotoConfig = "/Configs/GetValidatePhotoConfig"; //POST
  static final pathValidatePhoto = "/FR/ValidatePhoto"; //POST

}
