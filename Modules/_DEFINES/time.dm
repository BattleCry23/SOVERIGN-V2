// Time defines

#define SECONDS 10
#define MINUTES (60 * SECONDS)
#define HOURS (60 * MINUTES)
#define DAYS (24 * HOURS)

// Common time intervals
#define DS2TICKS(ds) ((ds) / 10)
#define TICKS2DS(ticks) ((ticks) * 10)

// Deciseconds (10ths of a second)
#define DECISECONDS 1

// Real time (1/100 second = 1 decisecond in BYOND)
#define REALTIME_SECONDS 100
