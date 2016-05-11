ansible-role-varnish
=====================

Configure varnish and its supporting daemons

Requirements
------------

None

Role Variables
--------------

| variable | description | default |
|----------|-------------|---------|

| Variable | Description | Default |
|----------|-------------|---------|
| varnish\_user | varnish user | {{ \_\_varnish\_user }} |
| varnish\_group | varnish group | {{ \_\_varnish\_group }} |
| varnish\_log\_user | varnishlog user | {{ \_\_varnish\_log\_user }} |
| varnish\_log\_dir | dir of varnishlog | {{ \_\_varnish\_log\_dir }} |
| varnish\_log\_file | path to varnishlog | {{ varnish\_log\_dir }}/varnish.log |
| varnish\_service | varnishd service name | varnishd |
| varnish\_package | package name | {{ \_\_varnish\_package }} |
| varnish\_conf\_dir | dir of varnishd | {{ \_\_varnish\_conf\_dir }} |
| varnish\_cache\_dir | path to file storage | {{ \_\_varnish\_cache\_dir }} |
| varnish\_storage | storage config to use | file,{{ varnish\_cache\_dir }},100M |
| varnish\_varnishd\_listen\_on | host and port to bind | :80 |
| varnish\_admin\_listen\_on | host and port to bind (varnishadm) | localhost:81 |
| varnish\_hash | hash config | classic,16383 |
| varnish\_extra\_flags | extra startup flags for varnishd | "" |
| varnish\_varnishlog\_service | service name of varnishlog | {{ \_\_varnish\_varnishlog\_service }} |
| varnish\_varnishncsa\_service | service name of varnishncsa | {{ \_\_varnish\_varnishncsa\_service }} |
| varnish\_varnishncsa\_dir | log dir of varnishncsa | {{ \_\_varnish\_varnishncsa\_dir }} |
| varnish\_varnishncsa\_file | path to varnishncsa log | {{ varnish\_varnishncsa\_dir }}/varnishncsa.log |
| varnish\_varnishncsa\_format | format of varnishncsa | {{ \_\_varnish\_varnishncsa\_format }} |
| varnish\_varnishadm\_secret | secret for varnishadm | "" |
| varnish\_vcl | dict of vcl (see below) | {} |


### FreeBSD

| Variable |  Default |
|----------|----------|
| \_\_varnish\_user | varnish |
| \_\_varnish\_group | varnish |
| \_\_varnish\_log\_user | varnishlog |
| \_\_varnish\_log\_dir | /var/log |
| \_\_varnish\_package | varnish4 |
| \_\_varnish\_db\_dir | /var/db/varnish |
| \_\_varnish\_conf\_dir | /usr/local/etc/varnish |
| \_\_varnish\_varnishlog\_service | varnishlog |
| \_\_varnish\_cache\_dir | /var/cache/varnish |
| \_\_varnish\_varnishncsa\_service | varnishncsa |
| \_\_varnish\_varnishncsa\_dir | /var/log/varnishncsa |
| \_\_varnish\_varnishncsa\_format | "" |


Dependencies
------------

None

Example Playbook
----------------


License
-------

BSD

Author Information
------------------

Tomoyuki Sakurai <tomoyukis@reallyenglish.com>
