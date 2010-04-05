<IfModule mod_rewrite.c>
    RewriteEngine  on
    # Uncomment this if mod_rewrites are not working for you. some hosting services have cranky mod_rewrite
    #RewriteBase /{$package}/
{literal}
    RewriteCond %{SCRIPT_FILENAME}              -f [OR]
    RewriteCond %{SCRIPT_FILENAME}/index.php    -f
{/literal}
{foreach from=$config.types key=typeName item=type name=types}

    # Rules for the type {$typeName}
    RewriteRule    ^{$typeName}$ list_{$typeName}.php [L,QSA]
    RewriteRule    ^{$typeName}/([0-9]+)$  view_{$typeName}.php?{$typeName}_id=$1  [L]
    RewriteRule    ^{$typeName}/edit/([0-9]+)$  edit_{$typeName}.php?{$typeName}_id=$1  [L]
    RewriteRule    ^{$typeName}/delete/([0-9]+)$  remove_{$typeName}.php?{$typeName}_id=$1  [L]
{/foreach}

    # =-=- CUSTOM BEGIN: htaccess -=-= #
{if !empty($customBlock.htaccess)}
    {$customBlock.htaccess}
{/if}
    # =-=- CUSTOM END: htaccess -=-= #

{literal}
</IfModule>
{/literal}