export URL_DO_PROVEDOR_OIDC=token.actions.githubusercontent.com

echo | openssl s_client -servername $URL_DO_PROVEDOR_OIDC -showcerts -connect $URL_DO_PROVEDOR_OIDC:443 2>/dev/null | sed -n '/-----BEGIN CERTIFICATE-----/{:start /-----END CERTIFICATE-----/!{N;b start}; /-----BEGIN CERTIFICATE-----/ p}' | openssl x509 -fingerprint -sha1 -noout | sed 's/SHA1 Fingerprint=//ig' | sed 's/://g'