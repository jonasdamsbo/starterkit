using System.Data.SqlTypes;
using System.Globalization;
using Ical.Net;
using Ical.Net.CalendarComponents;
using Ical.Net.DataTypes;
using Ical.Net.Serialization;

namespace Monolith.Logic.Services
{
	public class CalendarService
	{
		public string CreateSimpleEvent(
			string title,
			string description,
			string location,
			DateTime start,
			DateTime end)
		{
			var calendar = new Ical.Net.Calendar();

			var e = new CalendarEvent
			{
				Summary = title,
				Description = description,
				Location = location,
				Start = new CalDateTime(start),
				End = new CalDateTime(end)
			};

			calendar.Events.Add(e);

			var serializer = new CalendarSerializer();
			return serializer.SerializeToString(calendar);
		}
	}
}
