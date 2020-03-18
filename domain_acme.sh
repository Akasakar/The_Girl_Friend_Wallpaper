domain="my.domain.cf"
ssl_path="/etc/ssl"

function application()
{
    export CF_Email="Email"
    export CF_Key="https://dash.cloudflare.com/profile/api-tokens"

    ~/.acme.sh/acme.sh \
        --issue \
        --dns dns_cf \
        -k ec-256 \
        -d $domain

}

function install_cert()
{
    ~/.acme.sh/acme.sh \
        --installcert \
        --fullchainpath    $ssl_path/$domain.pem \
        --keypath          $ssl_path/$domain.key \
        --ecc \
        -d $domain
}

function merge_pem()
{
    cat $ssl_path/$domain.pem \
        $ssl_path/$domain.key | \
        tee $ssl_path/private/$domain.pem
}

#application
install_cert
merge_pem

