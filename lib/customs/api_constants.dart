class APIConstants {
  static const BASE_URL = "https://api.vimopay.co.in/api/";
  static const ENDPOINT_LOGIN = BASE_URL + "Login/Login";
  static const ENDPOINT_FORGOT_PASSWORD = BASE_URL + "Login/Passwordchange";
  static const ENDPOINT_GET_WALLETS = BASE_URL + "Balance/GetBalance";
  static const ENDPOINT_FETCH_TRANSACTION_REPORT =
      BASE_URL + "Balance/Alltranscationdetails_Idwise";
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
  static const ENDPOINT_GET_NOTICE = BASE_URL + "Dashboard/GetNotice";
  static const ENDPOINT_GET_COMMISSIONS =
      BASE_URL + "Balance/GetAllCommissionearned";
  static const ENDPOINT_COMPLAIN = BASE_URL + "Dashboard/Retailercomplain";
  static const ENDPOINT_REPORT_COMPLAIN =
      BASE_URL + "Dashboard/AddComplainsToAdmin";
  static const ENDPOINT_FETCH_MAIN_TXNS =
      BASE_URL + "Balance/GetAllMainwallettxn";
  static const ENDPOINT_FETCH_WALLET_TXNS =
      BASE_URL + "Balance/GetAllWallettxn";
  static const ENDPOINT_GET_ADMIN_LIST = BASE_URL + "Balance/GetAlladminlist";
  static const ENDPOINT_ADD_MONEY = BASE_URL + "Balance/RetailerAddmoney";
  static const ENDPOINT_MONEY_TRANSFER = BASE_URL + "Services/MoneyTransfer";
  static const ENDPOINT_RETAILER_SMS_ENQUIRE =
      BASE_URL + "Dashboard/RetailerSMSEnquire";
  static const ENDPOINT_CHANGE_PASSWORD =
      BASE_URL + "Credentials/Passwordchange";
  static const ENDPOINT_COMMISSION_REPORT =
      BASE_URL + "Balance/GetAllCommissionreport";
  static const ENDPOINT_RECHARGE_REPORT =
      BASE_URL + "Balance/GetAllRechargetxn";
  static const ENDPOINT_ATM_REPORT = BASE_URL + "Balance/GetAllATMWalletReport";

  // BBPS APIS
  // static const BBPS_BASE_URL = "https://digitalproxy-staging.paytm.com/billpay/";
  static const BBPS_BASE_URL = "https://billpayment.paytm.com/billpay/";
  static const ENDPOINT_SERVICE_LIST = BASE_URL + "Services/ServiceList";
}
