{literal}<IfModule mod_rewrite.c>
    RewriteEngine  on
    # Uncomment this if mod_rewrites are not working for you. some hosting services have cranky mod_rewrite
    #RewriteBase /{/literal}{$package}{literal}/
    RewriteCond %{SCRIPT_FILENAME}              -f [OR]
    RewriteCond %{SCRIPT_FILENAME}/index.php    -f
    RewriteRule ^(.*)$                          - [L]
    RewriteRule ^(.*)$  index.php?{/literal}{$package}{literal}_id=$1  [L,QSA]
</IfModule>
{/literal}