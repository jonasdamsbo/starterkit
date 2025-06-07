using Microsoft.AspNetCore.Components;

namespace Monolith.Logic.API.DTOs
{
	public class TestDto
	{
		public string MyString { get; set; }
		public int MyInt { get; set; }
		public List<string> StringList { get; set; }
		public string clickedString { get; set; }
		public int Counter { get; set; }

		public List<string> list1 { get; set; }

		public List<string> list2 { get; set; }

		public string Title { get; set; }

		public ElementReference elementRef;
		public Dictionary<string, string> elementStyles = new Dictionary<string, string>();
	}
}
