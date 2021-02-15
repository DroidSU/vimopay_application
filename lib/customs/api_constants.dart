class APIConstants {
  static const BASE_URL = "https://api.vimopay.co.in/api/";
  static const ENDPOINT_LOGIN = BASE_URL + "Login/Login";
  static const ENDPOINT_FORGOT_PASSWORD = BASE_URL + "Login/Passwordchange";
  static const ENDPOINT_GET_WALLETS = BASE_URL + "Balance/GetBalance";
  static const ENDPOINT_CHANGE_MOBILE_NUMBER =
      BASE_URL + "Credentials/Mobilechange";
  static const ENDPOINT_CHANGE_EMAIL_ADDRESS =
      BASE_URL + "Credentials/Emailchange";
  static const ENDPOINT_UPDATE_PROFILE_DETAILS =
      BASE_URL + "Credentials/Profileupdate";
  static const ENDPOINT_UPDATE_BANK_DETAILS =
      BASE_URL + 'Credentials/Bankchange';
  static const ENDPOINT_GET_BANK_DETAILS =
      BASE_URL + 'Credentials/Bankdetailsall';
  static const ENDPOINT_PREPAID_RECHARGE =
      BASE_URL + 'Services/PrePaidRecharge';
  static const ENDPOINT_DTH_RECHARGE = BASE_URL + 'Services/IcashDTH';
  static const ENDPOINT_VERIFY_IFSC = BASE_URL + 'Services/VerifyIfsc';
  static const ENDPOINT_GET_BANNER = BASE_URL + "Dashboard/GetBanner";
}
