<?php
// PayPal IPN listener for Dokuro Coin purchases

$raw_post_data = file_get_contents('php://input');
$raw_post_array = explode('&', $raw_post_data);
$myPost = array();
foreach ($raw_post_array as $keyval) {
    $keyval = explode('=', $keyval);
    if (count($keyval) == 2)
        $myPost[$keyval[0]] = urldecode($keyval[1]);
}

$req = 'cmd=_notify-validate';
foreach ($myPost as $key => $value) {
    $value = urlencode($value);
    $req .= "&$key=$value";
}

$paypal_url = "https://ipnpb.paypal.com/cgi-bin/webscr";
$ch = curl_init($paypal_url);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HEADER, false);
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_POSTFIELDS, $req);
curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, true);
$res = curl_exec($ch);
curl_close($ch);

if (strcmp($res, "VERIFIED") == 0) {
    $payer_email = $myPost['payer_email'];
    $receiver_email = $myPost['receiver_email'];
    $amount = floatval($myPost['mc_gross']);
    $currency = $myPost['mc_currency'];
    $txn_id = $myPost['txn_id'];
    $custom_key = trim($myPost['os0']); // FROM the first text box: BYOND KEY

    if ($receiver_email != "iconicdreamer5000@gmail.com") exit;
    if ($currency != "USD") exit;

    $dokuro_amount = intval($amount * 100);

    // Log full IPN
    $log = "[" . date('Y-m-d H:i:s') . "] $custom_key received $dokuro_amount Dokuro (TXN: $txn_id)\n";
    file_put_contents("ipn_logs.txt", $log, FILE_APPEND);

    // Save for BYOND to process
    if (!is_dir("pending")) mkdir("pending");
    $filename = "pending/" . md5($txn_id) . ".txt";
    file_put_contents($filename, "$custom_key|$dokuro_amount");

} else {
    file_put_contents("ipn_invalid.txt", "[" . date('Y-m-d H:i:s') . "] Failed IPN verification: $res\n", FILE_APPEND);
}
?>
