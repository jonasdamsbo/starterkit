using Microsoft.AspNetCore.Mvc;

namespace Monolith.Logic.Services
{
	public static class ICalBuilder
	{
		public static string CreateICalEvent(string uid, string summary, string description, DateTime start, DateTime end, string location)
		{
			return $@"BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//YourApp//EN
BEGIN:VEVENT
UID:{uid}
DTSTAMP:{DateTime.UtcNow:yyyyMMddTHHmmssZ}
DTSTART:{start:yyyyMMddTHHmmssZ}
DTEND:{end:yyyyMMddTHHmmssZ}
SUMMARY:{summary}
DESCRIPTION:{description}
LOCATION:{location}
END:VEVENT
END:VCALENDAR";
		}
	}
}
