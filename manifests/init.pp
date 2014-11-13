# == Class: elk
#
# Configure Elasticsearch, Logstash, and Kibana
#
# === Parameters
#
# None

# === Variables
#
# None
#
# === Examples
#
#  include elk
#
# === Authors
#
# Tim Freund <tim@freunds.net>
#
# === Copyright
#
# Copyright 2014 Tim Freund
#
class elk {
  package {'openjdk-7-jre-headless':
    ensure => installed,
  }

  class { 'elasticsearch': 
    package_url => 'https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.4.0.deb'
  }

  class { 'logstash': 
    package_url => 'https://download.elasticsearch.org/logstash/logstash/packages/debian/logstash_1.4.2-1-2c0f5a1_all.deb'
  }

  include 'kibana3'

  file {'/etc/elasticsearch/elasticsearch.yml':
    source => "puppet:///modules/elk/elasticsearch.yml",
    notify => Service["elasticsearch"],
    mode => 644,
    owner => root,
    group => root,
  }

  service {'elasticsearch':
    ensure => running,
  }

  service {'logstash':
    ensure => running,
  }

  File['/etc/elasticsearch/elasticsearch.yml'] -> Service['elasticsearch']
  Package['openjdk-7-jre-headless'] -> Package['logstash']
  Package['openjdk-7-jre-headless'] -> Package['elasticsearch']
}
