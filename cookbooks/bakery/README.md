bakery Cookbook
============

This cookbook contains a configure recipe that is used by Bakery to create and mange the develop environment databases and sites

Requirements
------------

### Platform
The release was tested on:

 * Ubuntu 14.04

May work with or without modification on other Debian derivatives.

### Cookbooks

 * database

Usage
------------
Simply include the bakery::configure recipe. The recipe will parse the node for "databases" and "sites" which should be defined as follows:

    "databases": {
        "database_one",
        "database_two"
    },
    "sites": {
      {
        "map" => "site_one",
        "to" => "/var/www/site_one"
      },
      {
        "map" => "site_two",
        "to" => "/var/www/site_two"
      }
    }

License & Authors
-----------------
- Author:: Kyle Klaus (indemnity83@gmail.com)

```text
Copyright 2014, Kyle Klaus

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
