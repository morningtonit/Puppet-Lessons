# Install class manages installation of ntp package
class ntp::install {

  case $::kernel {
    'Linux': {
      package { 'ntp':
        ensure => installed,
      }
    }
   default: {
      fail("Sorry, ${::kernel} is unsupported by this ntp module!")
    }
  }
}