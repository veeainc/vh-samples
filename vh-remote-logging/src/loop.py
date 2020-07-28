import logging
import time
import logging.handlers

my_logger = logging.getLogger('MyContainerLogger')
my_logger.setLevel(logging.DEBUG)

handler = logging.handlers.SysLogHandler(address = '/dev/log')

my_logger.addHandler(handler)

my_logger.debug('this is debug')
my_logger.critical('this is critical')
count=0
while True:
    count = count + 1
    my_logger.debug('logging from inside VH container - sleeping for 5 secs :%d',count)
    time.sleep(5)
