# Nextcloud with OnlyOffice

This nomad job file is used to run [Nextcloud](https://github.com/nextcloud/server) with [OnlyOffice](https://github.com/ONLYOFFICE/DocumentServer). Since OnlyOffice requires a lot of RAM, this job file reserves 2GB of RAM, 1.5GB for OnlyOffice, and 0.5GB for Nextcloud.

There are two things in this file you will want to change. In the `env` stanza of the `nextcloud` task, the admin username and password is set to "CHANGE ME". Set these to whatever username/password you prefer.

This job requires two volumes. One for Nextcloud's `/var/www/html` directory, which contains all of Nextcloud's files, and one for OnlyOffice's data. These should be called `nextcloud-html` and `onlyoffice-data` respectively, and they should both be read/write, not readonly.

Once Nextcloud is up and running, if you're using https, go to the `nextcloud-html` volume you created and edit `config/config.php`. There, you will want to add 

```php
'overwriteprotocol' => 'https',
```

right above the `trusted_domains`. This will tell Nextcloud to use https for its URLs. Once this is done, you can install the OnlyOffice connector app, and set the OnlyOffice URL in the settings to whatever domain you used for OnlyOffice.