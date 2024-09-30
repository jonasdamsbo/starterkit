using myshared.Models;

namespace myshared.DTOs
{
	public class ExampleDTO
	{
		public string Id { get; set; }
		public string? Title { get; set; }
		public string? Description { get; set; }

		public ExampleDTO() { }
		public ExampleDTO(ExampleModel example) =>
		(Id, Title, Description) = (example.Id, example.Title, example.Description);
	}
}
