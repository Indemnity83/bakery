# CakePHP Bakery

[![Latest Stable Version](https://poser.pugx.org/indemnity83/bakery/v/stable.svg)](https://packagist.org/packages/indemnity83/bakery) [![Total Downloads](https://poser.pugx.org/indemnity83/bakery/downloads.svg)](https://packagist.org/packages/indemnity83/bakery) [![Latest Unstable Version](https://poser.pugx.org/indemnity83/bakery/v/unstable.svg)](https://packagist.org/packages/indemnity83/bakery) [![License](https://poser.pugx.org/indemnity83/bakery/license.svg)](https://packagist.org/packages/indemnity83/bakery)

A delicious CakePHP development environment.

## Introduction

The CakePHP Bakery strives to make your local development environment delicious and easy by using

CakePHP Bakery is a pre-packaged Vagrant "box" that provides you a wonderful development environment without requiring you to install PHP, a web server, and any other server software on your local machine. No more worrying about messing up your operating system! Vagrant boxes are completely disposable. If something goes wrong, you can destroy and re-create the box in minutes!

Bakery runs on any Windows, Mac, or Linux system, and includes the Nginx web server, PHP 5.5, MySQL, Postgres, Redis, Memcached, and all of the other goodies you need to develop amazing CakePHP applications.

Note: If you are using Windows, you may need to enable hardware virtualization (VT-x). It can usually be enabled via your BIOS.

Bakery is currently built and tested using Vagrant 1.6.

## Included Software

 * Ubuntu 14.04
 * PHP 5.5
 * Nginx
 * MySQL
 * Postgres
 * Redis
 * Git
 * Composer
 * Memcached
 * Heroku Toolbelt

## Installation & Setup

### Installing VirtualBox & Vagrant

Before launching your Bakery environment, you must install [VirtualBox]() and [Vagrant](). Both of these software packages provide easy-to-use visual installers for all popular operating systems.

#### Vagrant Plugins

Bakery relies on a couple vagrant plugins to help things run smoothly. Installing vagrant plugins is super easy though, just run the following two commands to get all the plugins you need.

    vagrant plugin install vagrant-librarian-chef
    vagrant plugin install vagrant-omnibus

### Installing Bakery

Once VirtualBox and Vagrant have been installed, you are ready to install the Bakery CLI tool using the Composer global command:

    composer global require "indemnity83/bakery"

Make sure to place the ~/.composer/vendor/bin directory in your PATH so the bakery executable is found when you run the bakery command in your terminal.

Once you have installed the Bakery CLI tool, run the init command to create the Bakery.yaml configuration file:

    bakery init

The Bakery.yaml file will be placed in the ~/.bakery directory. If you're using a Mac or Linux system, you may edit Bakery.yaml file by running the bakery edit command in your terminal:

    bakery edit

### Set Your SSH Key

Next, you should edit the Bakery.yaml file. In this file, you can configure the path to your public SSH key, as well as the folders you wish to be shared between your main machine and the Bakery virtual machine.

Don't have an SSH key? On Mac and Linux, you can generally create an SSH key pair using the following command:

    ssh-keygen -t rsa -C "you@bakery"

On Windows, you may install Git and use the Git Bash shell included with Git to issue the command above. Alternatively, you may use PuTTY and PuTTYgen.

Once you have created a SSH key, specify the key's path in the authorize property of your Bakery.yaml file.

### Configure Your Shared Folders

The folders property of the Bakery.yaml file lists all of the folders you wish to share with your Bakery environment. As files within these folders are changed, they will be kept in sync between your local machine and the Bakery environment. You may configure as many shared folders as necessary!

### Configure Your Nginx Sites

Not familiar with Nginx? No problem. The sites property allows you to easily map a "domain" to a folder on your Bakery environment. A sample site configuration is included in the Bakery.yaml file. Again, you may add as many sites to your Bakery environment as necessary. Bakery can serve as a convenient, virtualized environment for every CakePHP project you are working on!

    sites:
    - map: homestead.app
      to: /home/vagrant/Code/Laravel/public

### Bash Aliases

To add Bash aliases to your Bakery box, simply add to the aliases file in the root of the ``~/.bakery` directory.

### Launch The Vagrant Box

Once you have edited the Bakery.yaml to your liking, run the `bakery up` command in your terminal. Bakery will boot the virtual machine, and configure your shared folders and Nginx sites automatically! To destroy the machine, you may use the `bakery destroy` command. For a complete list of available Bakery commands, run `bakery list`.

Don't forget to add the "domains" for your Nginx sites to the hosts file on your machine! The hosts file will redirect your requests for the local domains into your Bakery environment. On Mac and Linux, this file is located at `/etc/hosts`. On Windows, it is located at `C:\Windows\System32\drivers\etc\hosts`. The lines you add to this file will look like the following:

    192.168.10.10  bakery.app

Make sure the IP address listed is the one you set in your Bakery.yaml file. Once you have added the domain to your hosts file, you can access the site via your web browser!

    http://bakery.app

To learn how to connect to your databases, read on!


## Daily Usage

### Connecting Via SSH

To connect to your Bakery environment via SSH, issue the bakery ssh commnad in your terminal.

### Connecting To Your Databases

A bakery database is configured for both MySQL and Postgres out of the box. You'll need to set your CakePHP applications database.php (or .env) to connect to the database.

To connect to your MySQL or Postgres database from your main machine via Navicat or Sequel Pro, you should connect to 127.0.0.1 and port 33060 (MySQL) or 54320 (Postgres). The username and password for both databases is bakery / secret.

Note: You should only use these non-standard ports when connecting to the databases from your main machine. You will use the default 3306 and 5432 ports in your CakePHP database configuration file since CakePHP is running within the Virtual Machine.

### Adding Additional Sites

Once your Bakery environment is provisioned and running, you may want to add additional Nginx sites for your CakePHP applications. You can run as many CakePHP installations as you wish on a single Bakery environment. You may simply add the sites to your Bakery.yaml file and then run vagrant provision.

### Ports

The following ports are forwarded to your Bakery environment:

    SSH: 2222 -> Forwards To 22
    HTTP: 8000 -> Forwards To 80
    MySQL: 33060 -> Forwards To 3306
    Postgres: 54320 -> Forwards To 5432
