//URL
String productionBaseUrl = "https://api.getsafepay.com/";
String sandboxBaseUrl = "https://sandbox.api.getsafepay.com/";
String productionComponentUrl = "https://getsafepay.com/";
String sandboxComponentUrl = "https://sandbox.api.getsafepay.com/";

//ENDPOINTS
String fetchTokenEndpoint = "order/payments/v3/";
String authTokenEndpoint = "client/passport/v1/token";

//BODY FIELDS
String intent = "CYBERSOURCE";
String paymentmode = "payment";

//HEADERS KEYS
String secretKey = 'X-SFPY-MERCHANT-SECRET';

//SUCCESS PAYMENT URL VALUE
String successPaymentUrlContains = "external/complete";
String failPaymentUrlContains = "external/error";
