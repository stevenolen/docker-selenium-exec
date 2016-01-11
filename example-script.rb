require 'selenium-webdriver'
require 'socket'

router_url = ENV['ROUTER_URL'] || 'http://192.168.0.1'
router_user = ENV['ROUTER_USER'] || 'admin'
router_password = ENV['ROUTER_PASSWORD'] || 'admin'

$stdout.sync = true # cleaner stdout printing for docker logging..
print 'ensuring selenium is available...'
begin
  TCPSocket.new('selenium', 4444).close
  puts ' done.'
  true
rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
  print '.'
  sleep(1)
  retry # retry indefinitely. who knows why?
end

# Tested on Archer C7 v1, Firmware Version: 150511
# Hardware version v1 does not support 5GHz with dd-wrt
# and the software has severe service degredation every week
# or so and requires reboot. Since the web portal also generates
# a new url endpoint for every session (what??) it was easiest to 
# automate a reboot of the router using selenium.
driver = Selenium::WebDriver.for(:remote, url: 'http://selenium:4444/wd/hub', desired_capabilities: :chrome)
driver.navigate.to router_url
driver.find_element(:id, 'userName').send_keys router_user
driver.find_element(:id, 'pcPassword').send_keys router_password
driver.find_element(:id, 'loginBtn').click # clicks the login button 
driver.switch_to.frame 'bottomLeftFrame' # selects the left nav frame
driver.find_element(:id, 'a64').click # "System Tools" nav
driver.find_element(:id, 'a70').click # "Reboot" nav
driver.switch_to.default_content # unselects the left nav
driver.switch_to.frame 'mainFrame' # selects the main frame
driver.find_element(:id, 'reboot').click # clicks the reboot button
driver.switch_to.alert.accept # selects 'ok' on the reboot confirm dialog
wait = Selenium::WebDriver::Wait.new(timeout: 120) # router takes its good old time with a reboot
wait.until { driver.find_element(:id, 'userName') } # after a reboot, the session is gone so login will be displayed again.
driver.quit
