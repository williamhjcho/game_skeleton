<?php
require_once 'Parameters.php';
require_once 'class.phpmailer.php';
require_once 'class.pop3.php';
require_once 'class.smtp.php';
class Functions
{
    static function clearString($string)
    {
        if (get_magic_quotes_gpc()) {
            $string = stripslashes($string);
        }

        $string = mysql_real_escape_string($string);
        return $string;
    }

    static function getSentData($string, $defaultValue)
    {

        $result =Functions::clearString($defaultValue);

        if (isset($_POST[$string])) {
            $result = Functions::clearString($_POST[$string]);
        } else if (isset($_GET[$string])) {
            $result = Functions::clearString($_GET[$string]);
        } else if (isset($_SESSION[$string])) {
            $result = Functions::clearString($_SESSION[$string]);
        }
        return $result;
    }


    static function curPageURL()
    {
        $pageURL = 'http';
        $var = 'off';
        if (isset($_SERVER["HTTPS"])) $var = $_SERVER["HTTPS"];

        if ($var == "on") {
            $pageURL .= "s";
        }
        $pageURL .= "://";
        if ($_SERVER["SERVER_PORT"] != "80") {
            $pageURL .= $_SERVER["SERVER_NAME"] . ":" . $_SERVER["SERVER_PORT"] . $_SERVER["REQUEST_URI"];
        } else {
            $pageURL .= $_SERVER["SERVER_NAME"] . $_SERVER["REQUEST_URI"];
        }
        //list($theLink,$theParams) =preg_split ("/[?]/", curPageURL());
        return $pageURL;
    }

    static function sendMail($subject, $msg, $email, $name, $labelFrom = "Suporte")
    {


//Create a new PHPMailer instance
        $mail = new PHPMailer();
//Tell PHPMailer to use SMTP
        $mail->IsSMTP();
//Enable SMTP debugging
// 0 = off (for production use)
// 1 = client messages
// 2 = client and server messages
        $mail->SMTPDebug = 2;
//Ask for HTML-friendly debug output
        $mail->Debugoutput = 'html';
//Set the hostname of the mail server
        $mail->Host = Parameters::$mailHost;
//Set the SMTP port number - 587 for authenticated TLS, a.k.a. RFC4409 SMTP submission
        $mail->Port = Parameters::$mailPort;
//Set the encryption system to use - ssl (deprecated) or tls
        //  $mail->SMTPSecure = 'tls';
//Whether to use SMTP authentication
        $mail->SMTPAuth = Parameters::$mailSMTPAuth;
//Username to use for SMTP authentication - use full email address for gmail
        $mail->Username = Parameters::$mailUserName;
//Password to use for SMTP authentication
        $mail->Password = Parameters::$mailPassword;
//Set who the message is to be sent from
        $mail->SetFrom(Parameters::$mailUserName, $labelFrom);
//Set an alternative reply-to address
        // $mail->AddReplyTo('replyto@example.com', 'First Last');
//Set who the message is to be sent to
        $mail->AddAddress($email, $name);
//Set the subject line
        $mail->Subject = $subject;
//Read an HTML message body from an external file, convert referenced images to embedded, convert HTML into a basic plain-text alternative body

        $msgSignature = ("<hr>");
        $msgSignature .= "<br><br>";
        $msgSignature .= ("Email enviado automaticamente pelo sistema. Não responda esta mensagem.");

        $msg = $msg . $msgSignature;

        $mail->MsgHTML($msg);
//Replace the plain text body with one created manually
        $mail->AltBody = $msg;
//Attach an image file
        // $mail->AddAttachment('images/phpmailer_mini.gif');

//Send the message, check for errors
        if (!$mail->Send()) {
            return "Mailer Error: " . $mail->ErrorInfo;
        } else {
            return "Message sent!";
        }
    }
}

?>
