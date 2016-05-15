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
| varnish\_cache\_size | cache size | 512M |
| varnish\_storage | storage config to use | file,{{ varnish\_cache\_dir }},{{ varnish\_cache\_size }} |
| varnish\_varnishd\_listen\_on | host and port to bind | :80 |
| varnish\_admin\_listen\_on | host and port to bind (varnishadm) | localhost:81 |
| varnish\_hash | hash config | classic,16383 |
| varnish\_extra\_flags | extra startup flags for varnishd | "" |
| varnish\_varnishlog\_enable | enable varnishlog service | false |
| varnish\_varnishlog\_service | service name of varnishlog | {{ \_\_varnish\_varnishlog\_service }} |
| varnish\_varnishlog\_flags | optional flags for varnishlog | "" |
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

    - hosts: localhost
      roles:
        - ansible-role-varnish
      vars:
        varnish_cache_size: 1024M
        varnish_log_dir: /var/log/varnish
        varnish_varnishncsa_file: "{{ varnish_log_dir }}/access.json"
        varnish_varnishncsa_format: '{ \"@fields\": { \"http\": { \"client\": \"%{X-Client-Address}i\", \"protocol\": \"%H\", \"request_method\": \"%m\", \"query_string\": \"%q\", \"http_host\": \"%{Host}i\", \"source_host\": \"%{X-Varnish-Host}o\", \"status\": \"%s\", \"url\": \"%U\", \"hitmiss\": \"%{Varnish:hitmiss}x\", \"x-varnish\": \"%{x-varnish}o\", \"content-type\": \"%{Content-Type}o\", \"content-length\": \"%{Content-Length}o\", \"x-restarts\": \"%{X-Restarts}o\", \"location\": \"%{Location}o\", \"content-encoding\": \"%{Content-Encoding}o\", \"referer\": \"%{Referer}i\", \"user-agent\": \"%{User-agent}i\", \"accept-encoding\": \"%{Accept-Encoding}i\", \"connection\": \"%{Connection}i\", \"x-varnish-backend\": \"%{X-Varnish-Backend}o\" } }, \"@version\": 1, \"@timestamp\": \"{{ "%{" }}%FT%T%z}t\" }'
        varnish_varnishadm_secret: password
        varnish_vcl:
          example:
            file: test/integration/example.vcl
          default:
            inline: |
              vcl 4.0;

              # Default backend definition. Set this to point to your content server.
              backend default {
                  .host = "127.0.0.1";
                  .port = "8080";
              }

              sub vcl_recv {
                  # Happens before we check if we have this in cache already.
                  #
                  # Typically you clean up the request here, removing cookies you don't need,
                  # rewriting the request, etc.
              }

              sub vcl_backend_response {
                  # Happens after we have read the response headers from the backend.
                  #
                  # Here you clean the response headers, removing silly Set-Cookie headers
                  # and other mistakes your backend does.
              }

              sub vcl_deliver {
                  # Happens when we have all the pieces we need, and are about to send the
                  # response to the client.
                  #
                  # You can do accounting or modifying the final object here.
              }

License
-------

BSD

Author Information
------------------

Tomoyuki Sakurai <tomoyukis@reallyenglish.com>
