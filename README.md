mysql_check_and_set_value
=========================

Puppet manifest which test value in MySQL DB and if not set it

In my case this manifest takes predefined hash with values for Openfire
and if one of them absent or differs then change it to given.

You may ask why it need if enough just UPDATE needed values at all?

Because in my case if properties were updated Openfire instance should be restarted,
but I do not want restart it each time.

Script shown as is for my needs.
All parameters defined in another manifests, but if You will want use it
for different scenario you may additionaly specify or parametrize 
table and column names in variable $cmdTestProperty and $cmdSetProperty