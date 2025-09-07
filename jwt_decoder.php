<?php
class JWT {
    public static function decode($jwt) {
        $parts = explode('.', $jwt);
        if (count($parts) != 3) {
            return false;
        }

        $payload = $parts[1];
        $payload = base64_decode(str_replace(['-', '_'], ['+', '/'], $payload));
        return json_decode($payload, true);
    }
}
?> 