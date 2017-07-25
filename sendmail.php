#!/usr/bin/php

<?php
require_once("Symfony/Component/Yaml/autoload.php");

use Symfony\Component\Yaml\Yaml;
use Symfony\Component\Yaml\Exception\ParseException;

include "Mail.php";
include "Mail/mime.php";

function sendmail($to, $subject, $text = NULL, $file = NULL)
{
    $crlf = "\n";
    $from = "Server <pro@paul-mesnilgrente.com>";
    $headers = array(
        "From" => $from,
        "To" => $to,
        "Subject" => $subject
    );
    try {
        $value = Yaml::parse(file_get_contents($_SERVER["HOME"]."/.mail_credentials.yml"));
    } catch (ParseException $e) {
        printf("Unable to parse the YAML string: %s", $e->getMessage());
        exit(0);
    }
    $host = $value["mailer"]["host"];
    $port = $value["mailer"]["port"];
    $username = $value["mailer"]["username"];
    $password = $value["mailer"]["password"];

    $mime = new Mail_mime(array("eol" => $crlf));

    if ($text != NULL)
        $mime->setTXTBody($text);
    if ($file != NULL)
        $mime->addAttachment($file, "text/plain");

    $body = $mime->get();
    $headers = $mime->headers($headers);

    $smtp = Mail::factory("smtp",
        array ("host" => $host,
        "port" => $port,
        "auth" => true,
        "username" => $username,
        "password" => $password));

    $mail = $smtp->send($to, $headers, $mime->get());

    if (PEAR::isError($mail)) {
        echo($mail->getMessage()."\n");
    }
}

function usage()
{
    echo "Usage:";
    echo "    ".$argv[0]." <to> <subject> [<text> <file>]";
}

$to = $argv[1];
$subject = $argv[2];
$text = (sizeof($argv) > 3) ? $argv[3] : NULL;
$file = (sizeof($argv) > 4) ? $argv[4] : NULL;

sendmail($to, $subject, $text, $file);
