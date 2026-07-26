var/global/MILLISECONDS = 0.01

#define WAVE_COUNT 2

var/global/DECISECONDS = 1 //the base unit all of these defines are scaled by, because byond uses that as a unit of measurement for some fucking reason

var/global/SECONDS = 10

var/global/MINUTES = SECONDS*60

var/global/HOURS = MINUTES*60

var/global/DAYS = HOURS*24
var/global/YEARS = DAYS*365 //fuck leap days, they were removed in 2069

var/global/TICKS = world.tick_lag

// Real time (1/100 second = 1 decisecond in BYOND)
var/global/REALTIME_SECONDS = 100

