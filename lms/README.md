# LMS

This is the nomad job file for the [Lightweight Music Server](https://github.com/epoupon/lms).

This job requires two volumes. One for data and one for media. These volumes should be named `lms-data` and `lms-media` respectively. The `lms-data` volume should be read/write, not readonly, while the `lms-media` volume can be readonly.

LMS' user will not have permissions to write to the data directory. There are multiple ways to solve this. The easy way is to set the permissions of the directory to `777`. Since the directory won't contain any user data and the service will not be exposed directly to the internet, but rather go through a reverse proxy, this should be fine, but I still wouldn't recommend it. The more secure option is to enter the container's shell and chown the directory so that it is owned by the same user that's running LMS inside the container.